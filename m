Return-Path: <linux-kernel-owner+w=401wt.eu-S1757825AbYAPAnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825AbYAPAnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 19:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbYAPAnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 19:43:09 -0500
Received: from mail.suse.de ([195.135.220.2]:58423 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbYAPAnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 19:43:08 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 3 of 4] x86: clean up pte_modify
Date: Wed, 16 Jan 2008 01:43:02 +0100
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
References: <ddff52ae92d4f33bcba1.1200435428@localhost>
In-Reply-To: <ddff52ae92d4f33bcba1.1200435428@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801160143.03091.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 January 2008 23:17:08 Jeremy Fitzhardinge wrote:
> pte_modify() got mushed in an apparent mismerge.  Fix it up.

Note it's not just a clean up -- it would actually drop bits of the PFN.

-Andi
