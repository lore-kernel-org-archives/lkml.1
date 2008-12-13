Return-Path: <linux-kernel-owner+w=401wt.eu-S1751312AbYLMQpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312AbYLMQpS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 11:45:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbYLMQpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 11:45:04 -0500
Received: from rn-out-0910.google.com ([64.233.170.187]:45745 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbYLMQpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 11:45:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vPXs2a/2V/oKtdFuzAQwobQ3/RAfmA7P/l7r2r/Xcp6ZVhsvdfwIFNZQUJMcOFvGIt
         +WuDcmSXl+OjVGo1SlkEZYrTHtlmgvBO3cITjwV/q8FG9YAM/q3KRRVA/xRjtPBDWFlU
         /f+dsG6K63PwXgMlZN2kYyWti/iWw0Kyf3wvQ=
Message-ID: <ca2dc2820812130844i6b3ca8d2n39af8383b6f428d@mail.gmail.com>
Date: Sat, 13 Dec 2008 17:44:59 +0100
From: "Miguel Ojeda" <miguel.ojeda.sandonis@gmail.com>
To: "Giangiacomo Mariotti" <giangiacomo.mariotti@gmail.com>
Subject: Re: [PATCH] Misuse of sizeof
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <2aac3c260812130831m3ec4aa5cm3abd729499727873@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2aac3c260812130831m3ec4aa5cm3abd729499727873@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2008 at 5:31 PM, Giangiacomo Mariotti
<giangiacomo.mariotti@gmail.com> wrote:
> IMO there's a bug in the use of sizeof in /arch/x86/boot/main.c, it's
> also a strange style.
>

It is not a bug. You don't need to use parenthesis when used on
variables. See 6.5.3.4.
