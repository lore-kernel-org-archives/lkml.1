Return-Path: <linux-kernel-owner+w=401wt.eu-S1754034AbZFFLaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbZFFLaJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 07:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbZFFL36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 07:29:58 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:40611 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbZFFL35 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 07:29:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=f+9gBYPdWh1Lq0hf1Tfgxp2QZDc8rKifAXh72kGJWdVTwiTGyWn9n39EkYtO9bXkhn
         EWm3TkmOTFhu+jOlH5/GgwLkNny5SKXzi2juy76FbpdPKO/ExggZqY99bTq7c4J/N0AP
         Do8/Ma5CCnjgdD0SiyZDe09ebMnujRayoP13o=
MIME-Version: 1.0
In-Reply-To: <1244286691.3185.42.camel@myhost>
References: <1244285472.3185.36.camel@myhost> <1244286691.3185.42.camel@myhost>
Date: Sat, 6 Jun 2009 14:29:58 +0300
X-Google-Sender-Auth: b49dfd370ae675db
Message-ID: <84144f020906060429p2f865d85pb41357833a917826@mail.gmail.com>
Subject: Re: [PATCH V2] no need for checking it
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Figo.zhang" <figo1802@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Ian Abbott <abbotti@mev.co.uk>,
       Frank Mori Hess <fmhess@users.sourceforge.net>,
       David Schleef <ds@schleef.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 6, 2009 at 2:11 PM, Figo.zhang <figo1802@gmail.com> wrote:
> vfree() does it's own NULL checking,so no need for check before
> calling it.
>
> 'pages' is local variable argment,so in v2, it is no need assignment
>  to NULL.
>
> Signed-off-by: Figo.zhang <figo1802@gmail.com>

Looks good to me.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
