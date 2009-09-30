Return-Path: <linux-kernel-owner+w=401wt.eu-S1753986AbZI3CpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbZI3CpH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 22:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753899AbZI3CpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 22:45:06 -0400
Received: from mail-vw0-f203.google.com ([209.85.212.203]:37084 "EHLO
	mail-vw0-f203.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbZI3CpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 22:45:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=FY63LI6F86QntJAQfJ3n2MAdsJM9jyAGWifF63AB5NUNQot7bclyu3EUWaoeyJZelD
         VjYIEJudx6/ADC681KgPMj2Sy61CHdNWEkOvfdjCNSb9yqeGbUAb5xVFoxlk1c1tnYDF
         UhV6/v1EL2gEPoYzAZNrOqMeAAg8NDs2Azb7U=
MIME-Version: 1.0
In-Reply-To: <1254133004-24877-1-git-send-email-21cnbao@gmail.com>
References: <1254133004-24877-1-git-send-email-21cnbao@gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 29 Sep 2009 22:44:48 -0400
Message-ID: <8bd0f97a0909291944q53a060buc7bcbb30c1240da7@mail.gmail.com>
Subject: Re: [PATCH] Fix half-Y2K38 problem in timecompare_update while 
	calculating offset
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, davem@davemloft.net, patrick.ohly@intel.com,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 06:16, Barry Song wrote:
> ktime will overflow from 03:14:07 UTC on Tuesday, 19 January 2038,
> ktime_add() in timecompare_update() will overflow a half earlier.
> As a result, wrong offset will be gotten, then cause some strange
> problems.

Barry: you forgot to include your s-o-b tag ...
-mike
