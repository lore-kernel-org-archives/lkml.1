Return-Path: <linux-kernel-owner+w=401wt.eu-S1761996AbXGQNCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761996AbXGQNCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 09:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbXGQNCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 09:02:21 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:6996 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbXGQNCV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 09:02:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=O99N3DgbypMm7dat1Apgvgt45FdnmIhBA6hsMvY6cBIAT4B+bILab0QmdsboPIYZPpQ5FQBhFIQsrFS0mpc3/hz1fNsBUX0JsZH3Wmq9PT29NbLHVUooUUbTuOT/6JWJr7ZP2G2VpUdwFMt9ZAScyq/lFB/tiVCnkV5CLrKepew=
Message-ID: <d120d5000707170602g5311e048we02f1269de9769d5@mail.gmail.com>
Date: Tue, 17 Jul 2007 09:02:19 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "=?ISO-8859-1?Q?N=E9meth_M=E1rton?=" <nm127@freemail.hu>
Subject: Re: [PATCH 1/3] leds-clevo-mail: export i8042_command()
Cc: "Richard Purdie" <rpurdie@rpsys.net>, linux-input@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, "Rodrigo Pereira" <rodripe@gmail.com>
In-Reply-To: <469C976B.3030206@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <469C976B.3030206@freemail.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/17/07, Németh Márton <nm127@freemail.hu> wrote:
> From: Márton Németh <nm127@freemail.hu>
>
> Export the i8042_command() function which manages the mutual exclusion
> with the help of the i8042_lock spinlock. This lets possible to use the
> i8042 hardware safely from other part of the kernel, too.
>
> Signed-off-by: Márton Németh <nm127@freemail.hu>

Please #include <linux/i8042.h> into i8042.c. Doing so saves from
nasty surprises later.

-- 
Dmitry
