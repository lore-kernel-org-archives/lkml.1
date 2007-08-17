Return-Path: <linux-kernel-owner+w=401wt.eu-S1763131AbXHQVmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763131AbXHQVmm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 17:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbXHQVme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 17:42:34 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:27948 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbXHQVmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 17:42:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=BVDGPqMKuEV4zkbGHF+dYk+p/fEHVDsaghlc+7x96/QApm1y1DpMsxbxR05pzU1daZXgVjQpkEjPdNcuzNzmqsRQADi1c3SVXP4MqXin9IYx+yGROKG0WQ71nXdzhoTuekym7i0L84C9P9xSM6xq/XyBnEfnh9SX4AP5h2KodPE=
Message-ID: <84144f020708171442x52b18722k2971ceef96d3e72@mail.gmail.com>
Date: Sat, 18 Aug 2007 00:42:32 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: kfree(0) - ok?
Cc: "Satyam Sharma" <satyam@infradead.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Tim Bird" <tim.bird@am.sony.com>,
       "linux kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0708171413190.9635@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46C233CB.9000602@am.sony.com>
	 <1187132149.2618.2.camel@laptopd505.fenrus.org>
	 <alpine.LFD.0.999.0708150454480.6482@enigma.security.iitk.ac.in>
	 <20070817112253.e6a7cb33.akpm@linux-foundation.org>
	 <alpine.LFD.0.999.0708180011570.3666@enigma.security.iitk.ac.in>
	 <Pine.LNX.4.64.0708171413190.9635@schroedinger.engr.sgi.com>
X-Google-Sender-Auth: 759dc95915f83753
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/18/07, Christoph Lameter <clameter@sgi.com> wrote:
> That was merged over my objections. IMHO ksize(NULL) should fail since we
> are determining the size of an unallocated object.

Agreed, especially as we have real zero-sized objects returned from
kmalloc() et al now.
