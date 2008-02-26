Return-Path: <linux-kernel-owner+w=401wt.eu-S1759987AbYBZG1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987AbYBZG1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 01:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbYBZG1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 01:27:34 -0500
Received: from wx-out-0506.google.com ([66.249.82.224]:60628 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbYBZG1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 01:27:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Qm2IasA8poKZnZX1d+xyFfBTq8mryycIgfo53vX5IcyyzL6xuh3/IW4plBaRRbNrVFbjZmNZ27LA8Hu1ueeT6fcs34P87TEeYsi6rn/vFCXnkWjnwKiB9Rq7qF07EF0cWgMLyxq4ag2wC+wfrwupNgVN+g/N/niaMs+jEUUIHV4=
Message-ID: <84144f020802252227t729e8b0bif9c3c65e17304fd1@mail.gmail.com>
Date: Tue, 26 Feb 2008 08:27:32 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Nicholas Miell" <nmiell@comcast.net>
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, sandmann@redhat.com, tglx@tglx.de, hpa@zytor.com,
       levon@movementarian.org
In-Reply-To: <1203822747.2439.1.camel@entropy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080219123756.6261c13c@laptopd505.fenrus.org>
	 <20080223001130.d8922136.akpm@linux-foundation.org>
	 <84144f020802230351o24b11282vbb1cecf518d91825@mail.gmail.com>
	 <20080223104611.a3430285.akpm@linux-foundation.org>
	 <47C0DB2E.5000404@cs.helsinki.fi> <1203822747.2439.1.camel@entropy>
X-Google-Sender-Auth: d1dc948273e89eb3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2008 at 5:12 AM, Nicholas Miell <nmiell@comcast.net> wrote:
> > Sysprof tracks the full stack frame so it can provide meaningful call
> > tree (who called what) which is invaluable for spotting hot _paths_. I
> > don't see how oprofile can do that as it tracks instruction pointers only.
>
>  You could try passing the --callgraph option to opcontrol.

Hmm, perhaps I am missing something but I don't think that does what
sysprof does. At least I can't find where in the oprofile kernel code
does it save the full stack trace for user-space. John?

                        Pekka
