Return-Path: <linux-kernel-owner+w=401wt.eu-S1756305AbYBZGsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbYBZGsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 01:48:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbYBZGsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 01:48:16 -0500
Received: from wx-out-0506.google.com ([66.249.82.238]:16727 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbYBZGsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 01:48:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=hK5SheUegHtpLO/Jh3HEn3yXLGSeWbKg/KDYK0rC0Acu4e6SYKjL7RdHh2isScd1EUd6/XVyBNmt78bXtP9RneiF612Qcm3o5rO4s54eUuZKnadcNFjbuNt0GTkzHIPmN7UIwyeLWjtm+FvrxMJ0XJ6KrMEhGl6CIo+eX7LX3bU=
Message-ID: <84144f020802252248g7aa7c8dbx9ddf389f3962f836@mail.gmail.com>
Date: Tue, 26 Feb 2008 08:48:13 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Nicholas Miell" <nmiell@comcast.net>
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, sandmann@redhat.com, tglx@tglx.de, hpa@zytor.com,
       levon@movementarian.org
In-Reply-To: <84144f020802252227t729e8b0bif9c3c65e17304fd1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080219123756.6261c13c@laptopd505.fenrus.org>
	 <20080223001130.d8922136.akpm@linux-foundation.org>
	 <84144f020802230351o24b11282vbb1cecf518d91825@mail.gmail.com>
	 <20080223104611.a3430285.akpm@linux-foundation.org>
	 <47C0DB2E.5000404@cs.helsinki.fi> <1203822747.2439.1.camel@entropy>
	 <84144f020802252227t729e8b0bif9c3c65e17304fd1@mail.gmail.com>
X-Google-Sender-Auth: 12da01cc5833e6da
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Feb 26, 2008 at 8:27 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> >  You could try passing the --callgraph option to opcontrol.
>
>  Hmm, perhaps I am missing something but I don't think that does what
>  sysprof does. At least I can't find where in the oprofile kernel code
>  does it save the full stack trace for user-space. John?

Ok, so as pointed out by Nicholas/Andrew, oprofile does indeed do
exactly what sysprof does (see
arch/x86/oprofile/backtrace.c::backtrace_address, for example). So,
Soeren, any other reason we can't use the oprofile kernel module for
sysprof?
