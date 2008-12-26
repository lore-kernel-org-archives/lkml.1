Return-Path: <linux-kernel-owner+w=401wt.eu-S1752875AbYLZBkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbYLZBkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 20:40:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbYLZBkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 20:40:07 -0500
Received: from main.gmane.org ([80.91.229.2]:36627 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480AbYLZBkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 20:40:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitaram Chamarty <sitaramc@gmail.com>
Subject: Re: [ANNOUNCE] GIT 1.6.1
Followup-To: gmane.comp.version-control.git
Date: Fri, 26 Dec 2008 01:38:16 +0000 (UTC)
Organization: disorganised!
Message-ID: <slrngl8dc8.klo.sitaramc@sitaramc.homelinux.net>
References: <7v7i5odams.fsf@gitster.siamese.dyndns.org>
 <20081225114443.GD6115@zakalwe.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: atcmail.atc.tcs.co.in
User-Agent: slrn/0.9.9 (Linux)
Cc: git@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

["Followup-To:" header set to gmane.comp.version-control.git.]
On 2008-12-25, Heikki Orsila <shdl@zakalwe.fi> wrote:
> * What would be the probability for a single bit flip to corrupt the 
> repository?

> * And what is the situation where a single bit flip can not corrupt the 
> database?

These two questions are not specific to git; whatever
answers apply to sha1 also apply here.  Sha1 will always be
strong enough to detect any combination of random errors.
As for deliberate attacks, it is considered strong enough to
resist all but the most computationally intensive attacks
(the kind that require a worldwide effort or maybe NSA type
facilities).

> * When (which commands/functions) is error detection done?

"git fsck --full" will do it of course, but I'm not sure
what other operations also start off or end up doing a
check.

