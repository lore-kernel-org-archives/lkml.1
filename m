Return-Path: <linux-kernel-owner+w=401wt.eu-S1756430AbYCaCX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430AbYCaCX0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 22:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754901AbYCaCXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 22:23:09 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:18309 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437AbYCaCXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 22:23:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JGed5QzCab5N03bLva523405kAvS3HUtGTok7ABj1mSTFh7FldQtlxEIWO1cl+o0COaNW/M9+Rdgq5SVYizOGCyA2BozgGfNxf3AMtPxGq6YkG4qm4mIlDXeh4+dlkN+RhJUH7FCwJanwiBinqkqjnajluH6QaKO/rCX8kg6hsY=
Message-ID: <86802c440803301923m29b6a0coca7f61975331cbe5@mail.gmail.com>
Date: Sun, 30 Mar 2008 19:23:07 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jack Steiner" <steiner@sgi.com>
Subject: Re: [PATCH 8/8] x86_64: Support for new UV apic
Cc: "Andi Kleen" <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080331021224.GB20619@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080328191216.GA16455@sgi.com>
	 <86802c440803301622j2874ca56t51b52a54920a233b@mail.gmail.com>
	 <86802c440803301833r2229900cw99129515822dc373@mail.gmail.com>
	 <20080331021224.GB20619@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2008 at 7:12 PM, Jack Steiner <steiner@sgi.com> wrote:
> > >  Did you test it on non UV_X2APIC box?
>  >
>  > anyway the read_apic_id is totally wrong, even for your UV_X2APIC box.
>  > because id=apic_read(APIC_ID) will have apic_id at bits [31,24], and
>  > id |= __get_cpu_var(x2apic_extra_bits) is assuming that is on bits [5,0]
>  >
>  > so you even didn't test in your UV_X2APIC box!
>  >
>
>  It works fine on UV_X2APIX boxes because the double shift does
>  not occur. However, support for UV_X2APIC is dependent on
>  x2apic code that is not yet in the tree. Once the APIC
>  is switched into x2apic mode, the apicid is located in the LOW
>  bits of the apicid register, not the HIGH bits.

oh, so that will need have new version GET_APIC_ID too.

YH
