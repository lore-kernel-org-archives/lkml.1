Return-Path: <linux-kernel-owner+w=401wt.eu-S1753372AbZGTVCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbZGTVCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 17:02:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbZGTVCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 17:02:11 -0400
Received: from web50103.mail.re2.yahoo.com ([206.190.38.31]:20906 "HELO
	web50103.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751219AbZGTVCL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 17:02:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=2mm1RGd/no6d0yWh8KEwxiRqXOVnfgJ4GT4kHQs20sZqVrKOUMDj+RRvNwEBdEN5L9HyH+vxJEZOnBFsDwp+XwXeyd2bglvCcKE7T+0bKu516cyB63dTHN97Fcw113QHi0ERFVp5RwUsj2erkUmZDUC/nLY8g4t3bSclNgRmjPM=;
Message-ID: <526340.68353.qm@web50103.mail.re2.yahoo.com>
X-YMail-OSG: 0Z.J_nQVM1mGJ0MV7tCkKKW11EMjaE2WOvbbzMRDjalxQXANBrZcOeNMRlJ7YmlpqSzjOdf_mIIXIoqNziDZWG9IV912vkvOU66UTMiB5jJdU_BtGD3pYdHMN077j0g342g9thjXOVKSvsTeH.Dk78NJJVzvCRjL5v5oA4v57SR.A9mz5JSsJ9xV6jSGXT84CSQaGyNu1w4g.kQFyzzspiRSAluZBN.K0DK8oYZZ_QU5Y0EwNNM9d3eVBb9SGTgxYuozFZtIUBrNq.tMrx_e8iet0XvDteEVIJYooXWlRb.2UHqeOG7YDQXMxF02Cu77WN2udCU2uveanjpW_6rl
X-Mailer: YahooMailClassic/6.0.18 YahooMailWebService/0.7.338.1
Date: Mon, 20 Jul 2009 14:02:10 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH 07/14] mce3: pass mce info to EDAC for decoding
To: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>, mingo@elte.hu,
       tglx@linutronix.de, aris@redhat.com, linux-kernel@vger.kernel.org,
       x86@kernel.org
In-Reply-To: <4A64D0F2.7050009@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Mon, 7/20/09, H. Peter Anvin <hpa@zytor.com> wrote:

> From: H. Peter Anvin <hpa@zytor.com>
> Subject: Re: [PATCH 07/14] mce3: pass mce info to EDAC for decoding
> To: "Andi Kleen" <andi@firstfloor.org>
> Cc: "Doug Thompson" <norsk5@yahoo.com>, "Borislav Petkov" <borislav.petkov@amd.com>, mingo@elte.hu, tglx@linutronix.de, aris@redhat.com, linux-kernel@vger.kernel.org, x86@kernel.org
> Date: Monday, July 20, 2009, 2:17 PM
> Andi Kleen wrote:
> >> The goal is to have a default handler within the
> kernel and a more specific handler in a module after it has
> loaded. Using the weak symbol as a mechanism to do that. I
> haven't used that, so I don't know if it works.
> > 
> > weak symbols don't work over kernel modules.
> > 
> 
> For modules, you typically have to have a callback to
> update an internal
> function pointer.  If you think about it, it's pretty
> obvious -- a weak
> symbol changes the behavior at link time, but it's still a
> static call.
>  If you want modules to change the behavior, you're talking
> about a
> *dynamic* change -- the call will point to different things
> at different
> points in time -- so you need another mechanism, i.e.
> function pointers.
> 
>     -hpa

Thanks, that is exactly what I just posted in another reply.

now I understand weak symbols a bit better now as well

doug t 
