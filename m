Return-Path: <linux-kernel-owner+w=401wt.eu-S1762551AbXGPKQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762551AbXGPKQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 06:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755318AbXGPKQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 06:16:31 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:15787 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756939AbXGPKQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 06:16:31 -0400
Date: Mon, 16 Jul 2007 12:16:29 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Z. Cliffe Schreuders" <c.schreuders@murdoch.edu.au>
cc: linux-kernel@vger.kernel.org
Subject: Re: Including STRTOK_R in a LSM
In-Reply-To: <469B31E8.6050906@murdoch.edu.au>
Message-ID: <Pine.LNX.4.64.0707161214140.686@fbirervta.pbzchgretzou.qr>
References: <469B31E8.6050906@murdoch.edu.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 16 2007 16:52, Z. Cliffe Schreuders wrote:
>
> I am aware strtok was removed from the kernel in 2002. However strtok_r is more
> desirable than strsep as I do not want to know about 'blank fields' (2
> consecutive delimiters). Is it acceptable to simply include the strtok_r code
> in my security module? or should I create a wrapper for strsep to ignore
> blanks?

12:16 ichi:/dev/shm > cat test.c 
#include <stdio.h>
#include <string.h>
int main(void)
{
        char x[] = "foo::bar";
        char *w = x;
        char *p;
        while ((p = strsep(&w, ":")) != NULL)
                printf("\"%s\"\n", p);
}
12:16 ichi:/dev/shm > ./a.out 
"foo"
""
"bar"


q.e.d.


	Jan
-- 
