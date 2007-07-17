Return-Path: <linux-kernel-owner+w=401wt.eu-S1761079AbXGQNEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761079AbXGQNEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 09:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbXGQNEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 09:04:37 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:7664 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbXGQNEg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 09:04:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=edvhTmyl79JbBc2eYOUqL1pDuTCXZoD6CnyiEVmxkNkwpPIgvcJDO8V/ide6iAr1/tn9364704h/Y1cbJ2zGs7CUVb2h/0tF8z/rax6PR4XPup9L4p/tIzhOUSHXn9w/p16J16FHaok6ww42PRShTPVOcT4Uu5vo9v3z8TuHP4U=
Message-ID: <d120d5000707170604q2e3c0d36g9bea02f4ed3d3050@mail.gmail.com>
Date: Tue, 17 Jul 2007 09:04:34 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "=?ISO-8859-1?Q?N=E9meth_M=E1rton?=" <nm127@freemail.hu>
Subject: Re: [PATCH 2/3] leds-clevo-mail: hw accelerated LED blink extension
Cc: "Richard Purdie" <rpurdie@rpsys.net>, linux-input@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, "Rodrigo Pereira" <rodripe@gmail.com>
In-Reply-To: <469C977A.8000908@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <469C977A.8000908@freemail.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/17/07, Németh Márton <nm127@freemail.hu> wrote:
>
> +Hardware accelerated blink of LEDs
> +==================================
> +
> +Some LEDs can be programmed to blink without any CPU interaction. To
> +support this feature, a LED driver can optionally implement the
> +blink_set() function (see <linux/leds.h>). If implemeted, the
> +ledtrig-timer tries to use it. The blink_set() function should return
> +1 if the blink setting is supported, or 0 otherwise, which means that
> +the LED will be turned on and off from software.

Normally object methods in kernel return 0 on success and error code
(such as -EINVAL for unsupported parameters) on error.

-- 
Dmitry
