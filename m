Return-Path: <linux-kernel-owner+w=401wt.eu-S1759031AbZIQSml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759031AbZIQSml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 14:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbZIQSmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 14:42:40 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:61764 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbZIQSmj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 14:42:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=EQiSJYj4EXepE3cvlAMmXrUdQprS0TC3LZgZgC7OxT/Cp/mOveNlD8ooZmCxMfCjSw
         NFOIA15rwB44hd32l8TIUMYxjN/xn5RGfkiTxeZeRqMhod90cxd/R/DmB1jytQd9VFYu
         cHmXeM6miYIh67KulP4QjznhdfbLE5Xu+x4Y4=
MIME-Version: 1.0
In-Reply-To: <20090917133401.GC24438@mit.edu>
References: <194f62550909090403x16e61cc1g3a23593085de0b@mail.gmail.com>
	 <194f62550909160532q248cb45coee639a2da10292a@mail.gmail.com>
	 <20090916163822.GA15451@mit.edu>
	 <194f62550909161141n5730049cra2643ce1654a7aaf@mail.gmail.com>
	 <20090917133401.GC24438@mit.edu>
Date: Thu, 17 Sep 2009 14:37:31 -0400
Message-ID: <194f62550909171137t10c28c33t438d2e75a347f95@mail.gmail.com>
Subject: Re: Howto switch off ext4's delayed allocation?
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thanks, but no need.  I did some investigating, and when I found that
> kwrite was doing a truncate-and-rewrite, I did some more digging, and
> found that we had a bug in our truncate hueristics.  I'll get this
> fixed for 2.6.32, and it will be a candidate for the 2.6.31 stable
> tree.

Cool, thanks a lot :)

- Clemens
