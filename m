Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbZA1XMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbZA1XMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:12:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbZA1XMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:12:13 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:33121 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbZA1XMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:12:12 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 29 Jan 2009 00:11:32 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH RFT 7/7] firewire: sbp2: add workarounds for 2nd and 3rd
 generation iPods
To: Jarod Wilson <jarod@redhat.com>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Kristian__H=F8gsberg?= <krh@bitplanet.net>
In-Reply-To: <200901281718.41873.jarod@redhat.com>
Message-ID: <tkrat.8899c8be7878fd1f@s5r6.in-berlin.de>
References: <tkrat.6fe4fe5b72231863@s5r6.in-berlin.de>
 <tkrat.b82b9fbc17b1a032@s5r6.in-berlin.de>
 <200901281718.41873.jarod@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarod Wilson wrote:
> On Saturday 24 January 2009 13:46:44 Stefan Richter wrote:
>>   - Do 2nd and 3rd gen. iPods actually have a model_id == 0, or do they
>>     have in fact no model_id at all?
> 
> So far as I can decipher (using Kristian's csr-dump utility), they really
> do have model_id == 0.

If model_id weren't there, the older ieee1394/sbp2 driver would log
model_id 0 (and match against quirks list entries with ID 0), while
firewire-sbp2 logs model_id 0xff000000 (which is an impossible value and
thus indicates to those who want to write a new quirks list entry that
there is actually no model_id...).  I will soon push the patch which
makes sbp2 behave like firewire-sbp2 in this regard, to eliminate a
potential source of conflicting user reports.
-- 
Stefan Richter
-=====-==--= ---= ===-=
http://arcgraph.de/sr/

