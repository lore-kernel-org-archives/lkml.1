Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbYARDsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbYARDsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 22:48:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbYARDs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 22:48:28 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:17083 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbYARDs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 22:48:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=wd1/WS3uLOMoVRr2fUqswRMWCEDQCn33QL4y+af/CV8wa0SVJKjieBdn0cupSA9vyJ8O9oNlWrXozKsAgkxNY+iVkHwC4tbn6wooD7jR9RE9+curc2n5AOaqwGwQzgsj4hX+YpwsG0REsPTNVH9rNuj2av+8VwG44NCLodKgPTM=
Message-ID: <86802c440801171948o152fc82eh6756926ead6882e7@mail.gmail.com>
Date: Thu, 17 Jan 2008 19:48:25 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: x86.git kexec rhel 5.1
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440801171911p3d82c39ap29da2d81c63c77c2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440801171911p3d82c39ap29da2d81c63c77c2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 17, 2008 7:11 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> some problem with PAT
>
> A: 1/17 x86.git with PAT enable kernel
> B. 1/17 x86.git with PAT diabled kernel
> C: RHEL 5.1 stock kernel -53
>
> A kexec B : OK
> B kexec A:  OK
> A kexec C: very slow
> B kexec C:  OK
> C kexec A:  OK
> C kexec B:  OK
>
> Do we need something to disable PAT when kexec calling shutdown?

change PAT only, fix that A kexec C problem.

YH
