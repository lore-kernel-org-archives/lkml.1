Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab0BSMC3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 07:02:29 -0500
Received: from mail-iw0-f196.google.com ([209.85.223.196]:43104 "EHLO
	mail-iw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab0BSMC2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 07:02:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mPLYgvyOmg0hK5dGgXAQXytWtRBlbf8gv9w97dePeSXKFHsL8XRWvXJxPgv/7iWgZM
         fEHnSNSxZZFZ3ygZ4dEWN1e5OVy7QdaFMlA4ZnboJEjoeSAhWwITO0URMt7wJs2DLKlH
         eIneuNm6Ohc0GAhdZ9kju4yOUiU613/WVfkVw=
MIME-Version: 1.0
In-Reply-To: <628d1651002190357q1b17cf76o6585ce957d610ed8@mail.gmail.com>
References: <628d1651002070324w424012eanda9392db26331905@mail.gmail.com>
	 <b6fcc0a1002190344s75ecfcf6y625591a0fa8e9869@mail.gmail.com>
	 <628d1651002190357q1b17cf76o6585ce957d610ed8@mail.gmail.com>
Date: Fri, 19 Feb 2010 14:02:27 +0200
Message-ID: <b6fcc0a1002190402y7aeef6bana21ad7d54a32777a@mail.gmail.com>
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

On Fri, Feb 19, 2010 at 1:57 PM, wzt wzt <wzt.wzt@gmail.com> wrote:
> Maybe, but The attackers will use a complicated way to find the
> security_ops address, it's a barrier to attackers.

It's not a barrier, it's garbage. Once you know the adress security_ops
ended up at, you simply write to it.

> LSM is security framework,  we don't want the attackers can easily
> to break it.

LSM doesn't protect kernel from kernel.

> Just like the sys_call_table variable in kernel 2.4.x(global and
> writeable), evil drivers can extern the variable,  then replace the
> Sys_X functions.

Not that easily, but they still can.
