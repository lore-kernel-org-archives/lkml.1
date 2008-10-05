Return-Path: <linux-kernel-owner+w=401wt.eu-S1753375AbYJEEqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbYJEEqR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 00:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbYJEEqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 00:46:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:37049 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbYJEEqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 00:46:04 -0400
Message-ID: <48E84608.5080108@kernel.org>
Date: Sun, 05 Oct 2008 13:43:52 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Stefan Lippers-Hollmann <s.L-H@gmx.de>, linux-kernel@vger.kernel.org,
       jgarzik@redhat.com, pchen@nvidia.com, stable@kernel.org
Subject: Re: patch sata_nv-disable-hardreset-for-generic.patch added to	2.6.26-stable
 tree
References: <20081001234424.C72C114543E5@imap.suse.de> <200810041827.04721.s.L-H@gmx.de> <20081005025401.GA22549@suse.de> <48E83272.7040709@kernel.org> <20081005034800.GA7802@suse.de>
In-Reply-To: <20081005034800.GA7802@suse.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 05 Oct 2008 04:45:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>> It's currently a mess.  Please take a look at the following message for
>> the whole story.
>>
>>   http://article.gmane.org/gmane.linux.ide/34942
>>
>> It's interesting how they fixed hardreset of the chipset step-by-step. :-(
> 
> Ick, you are right, what a mess.
> 
> Do you want that patch in 2.6.26-stable now?  Or just don't worry about
> it?

2.6.26-stable should be fixed but given the series of breakages I
wanna be a bit cautious before proceeding.  Just give me a few more
days so that I can confirm the posted patch fixes the problem for both
generic and nf2/3 flavors.  I'll forward the final patch against
-stable to you then.

Thanks.

-- 
tejun
