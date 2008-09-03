Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562AbYICG5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbYICG5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 02:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbYICG5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 02:57:39 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:28785 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbYICG5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 02:57:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vEBrxUpbnywBfbX+TQEc9EnmBX0wkfFkBloj7KViOANeZf7jekEik+ST38TNt4yXhX
         aiknxApyeWwIFLe4tz04pIwmGugn1CtO7RbIiZcMhlvC964N7Dzn09yxtQZoQwF3ojpy
         /Xej+xbH4Ia+ODEWeJe5y8SOYUQ6DDJY/Y0Yk=
Message-ID: <ac9c93b10809022357l79d014d3ybb40271b2ae806fd@mail.gmail.com>
Date: Wed, 3 Sep 2008 08:57:35 +0200
From: "Frans Meulenbroeks" <fransmeulenbroeks@gmail.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: CodingStyle question: multiple statements on a single line
Cc: LKML <linux-kernel@vger.kernel.org>,
       "v4l-dvb maintainer list" <v4l-dvb-maintainer@linuxtv.org>
In-Reply-To: <200809030021.00122.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200809030021.00122.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/3 Hans Verkuil <hverkuil@xs4all.nl>:
[...]
>
> "Don't put multiple statements on a single line unless you have
> something to hide:
>
>        if (condition) do_this;
>          do_something_everytime;
>
> Don't put multiple assignments on a single line either.  Kernel coding
> style is super simple.  Avoid tricky expressions."
>
> Does this mean:
>
> 1) Yes, after an 'if' you can put a single statement like this:
>
>        if (a) b;
>
> 2) No, never use the 'if (a) b;' construction. Put 'b;' on the next line
> instead.
>

It means 2. The example is definitely tricky. At first sight the
indentation suggests that the 'do_something-everytime" belongs to the
if, so it might put people on the wrong foot.
Suggest the text to be revised though. Some of us are better in
English than others. No need to cause confusion...

just my two eurocents :-)

Frans

[...]
