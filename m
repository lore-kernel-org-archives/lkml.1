Return-Path: <linux-kernel-owner+w=401wt.eu-S1754365AbZBGQl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbZBGQl4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 11:41:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbZBGQls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 11:41:48 -0500
Received: from mail-gx0-f21.google.com ([209.85.217.21]:47011 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbZBGQlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 11:41:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=aAE5I3MCW15vLgVyJbe+7r4JFeR5IyIrXjgroiyt8eW+V8+zDCu4TBEanAaVAWr4FC
         6nMehW9qwB89jicYZaC7lV/HN/1ZS0Y4YsLWuBBVDhk+IBkYtLQyrGKmGlUpWFGpA+ZT
         OE6tocXCVqzwbItrST1KFoaqTQAcErtilcfN8=
Message-ID: <498DB9C6.6080501@gmail.com>
Date: Sat, 07 Feb 2009 10:41:42 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Ben Greear <greearb@candelatech.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: PATCH:  (v2) Allow user to force 'tsc' to be treated as stable.
References: <498C817F.8070306@candelatech.com>
In-Reply-To: <498C817F.8070306@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Greear wrote:
> Allow user to force TSC to be treated as a stable clock-source.
> On some systems, with ACPI disabled in the BIOS, the
> kernel determines that the TSC is unstable, when it fact
> it appears to be fine.  This patch allows one to force
> the kernel to treat the tsc as stable.
> 
> This is against 2.6.29-rc3.
> 
> Signed-Off-By:  Ben Greear<greearb@candelatech.com>

I don't think this is a good solution. If the TSC is in fact stable it 
would be better to fix the detection to detect it as such. If it's not 
then this will cause problems.
