Return-Path: <linux-kernel-owner+w=401wt.eu-S1764817AbXJONNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764817AbXJONNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 09:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759572AbXJONNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 09:13:07 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:5093 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759403AbXJONNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 09:13:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fzkO+5FrjEGWDOzW9DmZw2Ad1sEzyjTFRLRRkvEricD/9AFLALr/5FU3lpAj0SfGWZX3MNocZptb2+vM2QG/tXrlUvtI6K2Gifn37CCu2oCBCFxFRP6SxmQxgt+yhzDR5gHNEII9eMtHxxmO9RWbHj2jqbrsQ2XFn7HojV2/Ie8=
Message-ID: <d120d5000710150613i316170c7y11a1fcfe5d6c003c@mail.gmail.com>
Date: Mon, 15 Oct 2007 09:13:02 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Philip Langdale" <philipl@overt.org>
Subject: Re: [PATCH] Input: Refactor evdev 32bit compat to be shareable with uinput
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <471118B5.7050503@overt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <471118B5.7050503@overt.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philip,

On 10/13/07, Philip Langdale <philipl@overt.org> wrote:
> Currently, evdev has working 32bit compatibility and uinput does not. uinput
> needs the input_event code that evdev uses, so let's refactor it so it can
> be shared.
>

Looks very good, thank you. I just think that we should keep
input_compat.h in drivers/input instead of include/linux and never
show to anyone ;). I will change it on my side.

-- 
Dmitry
