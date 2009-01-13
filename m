Return-Path: <linux-kernel-owner+w=401wt.eu-S1757331AbZAMEP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331AbZAMEP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 23:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbZAMEPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 23:15:18 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:57926 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031AbZAMEPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 23:15:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eQFDhYvKFDTTOAeTw9BL7iRpEcsqSj8xVAs/SmLqc8fqBx1qpZcQ8J2kObd0vjTEni
         Q3C1i6xWgPRgBBpO5NUltu5dVzX5FKxvpz5DQv2khPSDJlaqhyAIKdOK+TBZANgtZVS3
         KGjYpN5JOLgocd6+5l0suFg6mAmRs3MQhROZg=
Message-ID: <ce0170d90901122015q564b8d3cwc5a6463ec2896885@mail.gmail.com>
Date: Tue, 13 Jan 2009 01:15:14 -0300
From: "Sergio Luis" <eeeesti@gmail.com>
To: "Amit Joshi" <ajoshi@advisen.com>
Subject: Re: Error Building 2.6.29-rc1 on Debian using make-kpkg
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <496C05D2.2090001@advisen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <496C05D2.2090001@advisen.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 12:09 AM, Amit Joshi <ajoshi@advisen.com> wrote:
> Hello,
>
> I get the following error when building the 2.6.29-rc1 kernel on a Thinkpad
> T61 running Debian Lenny (with a few unstable and experimental packages).
> The command line used to compile was
>
> make-kpkg --initrd --append-to-version a1 -uc -us buildpackage.
>
> The config file is attached.
>
> CC [M] drivers/net/irda/nsc-ircc.o
> CC [M] drivers/net/irda/w83977af_ir.o
> CC [M] drivers/net/irda/donauboe.o
> drivers/net/irda/donauboe.c: In function 'toshoboe_interrupt':
> drivers/net/irda/donauboe.c:1197: error: 'struct toshoboe_cb' has no member
> named 'stats'
> drivers/net/irda/donauboe.c:1201: error: 'struct toshoboe_cb' has no member
> named 'stats'
> drivers/net/irda/donauboe.c:1283: error: 'struct toshoboe_cb' has no member
> named 'stats'
> make[6]: *** [drivers/net/irda/donauboe.o] Error 1
> make[5]: *** [drivers/net/irda] Error 2
> make[4]: *** [drivers/net] Error 2
> make[3]: *** [drivers] Error 2
> make[3]: Leaving directory `/repository/src/linux/2.6.29/linux-2.6.28'
> make[2]: *** [debian/stamp/build/kernel] Error 2
> make[2]: Leaving directory `/repository/src/linux/2.6.29/linux-2.6.28'
> make[1]: *** [debian/stamp/do-build-arch] Error 2
> make[1]: Leaving directory `/repository/src/linux/2.6.29/linux-2.6.28'
> dpkg-buildpackage: failure: debian/rules build gave error exit status 2
> make: *** [debian/stamp/build/buildpackage] Error 2

try the patch here:
http://patchwork.kernel.org/patch/1753/

Sergio.
