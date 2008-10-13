Return-Path: <linux-kernel-owner+w=401wt.eu-S1757970AbYJMKYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970AbYJMKYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbYJMKYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 06:24:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:12318 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbYJMKYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 06:24:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fw9M/pr0Oh8e1APoi8xsvI3d2hmJEkVxePF+FbLKjoD8na/qoRqeRyIudlhAuUeQAI
         LFhGyQlVLkDRj4SmSBJonEUCvl7rihGJYbgSfzzBbwgqVnlDbzf0w5a3UmDBor5sYY1q
         2YXMmeV2TsJe3k3ngfF166XhCAA+9kWquIppg=
Message-ID: <8bd0f97a0810130324o17a2b98s6bb05670b814345d@mail.gmail.com>
Date: Mon, 13 Oct 2008 06:24:33 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Bryan Wu" <cooloney@kernel.org>
Subject: Re: [PATCH 1/1] netdev: DM9000: Added typecasting to supress some warnings on Blackfin
Cc: "Javier Herrero" <jherrero@hvsistemas.es>, jeff@garzik.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <386072610810130252s52c11423r69851740975ff517@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223889009-31336-1-git-send-email-cooloney@kernel.org>
	 <20081013091725.GG31627@trinity.fluff.org>
	 <48F314B7.3020708@hvsistemas.es>
	 <386072610810130252s52c11423r69851740975ff517@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 05:52, Bryan Wu wrote:
> On Mon, Oct 13, 2008 at 5:28 PM, Javier Herrero wrote:
>> So it seems that we must correct that in other place?
>
> Yes, we need to check the I/O read_write functions.

and drop the CONFIG_BLACKFIN hacks in the dm90000 driver ... we
rewrite the write* functions to out* ... probably because we dont
provide any write* functions in our headers
-mike
