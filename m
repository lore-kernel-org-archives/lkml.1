Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab0BSLot (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 06:44:49 -0500
Received: from mail-iw0-f196.google.com ([209.85.223.196]:51748 "EHLO
	mail-iw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab0BSLor convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 06:44:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=t04ay98IFuKXCbrgX14CULC/xo1hsKa8G88jpBQ0cAkXdJYWNhvMkLjoxw968xK7mZ
         AncTxxCI7p7YwI0ujKi0DexXjYaOamRQ2nyJWU1hsWdUKCcpeOE4Gl8t+oNyIwChDZB7
         YTaSxyQphyd4vZao57HXtTQK4VGPwxsNwVtCs=
MIME-Version: 1.0
In-Reply-To: <628d1651002070324w424012eanda9392db26331905@mail.gmail.com>
References: <628d1651002070324w424012eanda9392db26331905@mail.gmail.com>
Date: Fri, 19 Feb 2010 13:44:46 +0200
Message-ID: <b6fcc0a1002190344s75ecfcf6y625591a0fa8e9869@mail.gmail.com>
Subject: Re: [PATCH] LSM: add static to security_ops variable
From: Alexey Dobriyan <adobriyan@gmail.com>
To: wzt wzt <wzt.wzt@gmail.com>
Cc: linux-kernel@vger.kernel.org, sds@tycho.nsa.gov, jmorris@namei.org,
       eparis@parisplace.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 7, 2010 at 1:24 PM, wzt wzt <wzt.wzt@gmail.com> wrote:
> security_ops was declared as a global variable, so other drivers or
> kernel code can easily change its value, like:

With your patch they still can.

> extern struct security_operations *security_ops;
> security_ops = NULL;
>
> then insmod this driver immediately, it will get an oops.  Other evil
> drivers can aslo fake this variable as extern.
