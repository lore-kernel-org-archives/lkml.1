Return-Path: <linux-kernel-owner+w=401wt.eu-S932724AbZDIKGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724AbZDIKGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 06:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759096AbZDIKF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 06:05:59 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:51876 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758584AbZDIKF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 06:05:58 -0400
X-Sasl-enc: N5xnbwTost7sO+Nqf06lBQmbk0ge6kS9bGzck2RGBFXA 1239271557
Message-ID: <49DDC882.3050701@fastmail.fm>
Date: Thu, 09 Apr 2009 11:05:54 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: jeff@garzik.org, kernel-janitors@vger.kernel.org, ralf@linux-mips.org
Subject: Re: [PATCH 24/56] mips: Remove void casts
References: <> <1239189748-11703-10-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-11-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-12-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-20-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-21-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-22-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-23-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-24-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-25-git-send-email-jwjstone@fastmail.fm>
In-Reply-To: <1239189748-11703-25-git-send-email-jwjstone@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added maintainer CC]
Jack Stone wrote:
> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> ---
>  arch/mips/boot/elf2ecoff.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/mips/boot/elf2ecoff.c b/arch/mips/boot/elf2ecoff.c
> index c5a7f30..0a4cbf0 100644
> --- a/arch/mips/boot/elf2ecoff.c
> +++ b/arch/mips/boot/elf2ecoff.c
> @@ -136,7 +136,7 @@ static char *saveRead(int file, off_t offset, off_t len, char *name)
>  		fprintf(stderr, "%s: fseek: %s\n", name, strerror(errno));
>  		exit(1);
>  	}
> -	if (!(tmp = (char *) malloc(len))) {
> +	if (!(tmp = malloc(len))) {
>  		fprintf(stderr, "%s: Can't allocate %ld bytes.\n", name,
>  			len);
>  		exit(1);
>   

