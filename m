Return-Path: <linux-kernel-owner+w=401wt.eu-S1946110AbXEBAGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946110AbXEBAGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 20:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946111AbXEBAGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 20:06:54 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:43233 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946110AbXEBAGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 20:06:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=gDnzvTNRrQ4C/FoHpxcoAXY0XuOIAcUmRWCp6szdb7ZOcDza1tt94Eudn/fNgkLJdq/uJrB5n57OV3ZyN9GQojT+v0MVH7K7SYgB/KE33w77YAUM8eHMnV+UXGPFo1rTFAjVkluQL/CanCmlaVpH/bi00+mqVyufnkw0vg3jicE=
Message-ID: <75b66ecd0705011706r3200fcecvff00953264325f30@mail.gmail.com>
Date: Tue, 1 May 2007 20:06:52 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Subject: Re: 24 lost ticks with 2.6.20.10 kernel
Cc: "Michel Lespinasse" <walken@zoy.org>, "Chuck Ebbert" <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org, "Dave Jones" <davej@redhat.com>,
       "Jeb Cramer" <cramerj@intel.com>,
       "John Ronciak" <john.ronciak@intel.com>,
       "Jesse Brandeburg" <jesse.brandeburg@intel.com>,
       "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>
In-Reply-To: <4637BA70.8000108@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070501130715.GB29131@zoy.org> <46375E04.5030506@redhat.com>
	 <20070501214912.GA4048@zoy.org> <4637BA70.8000108@intel.com>
X-Google-Sender-Auth: cd2308f4c2bf60de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/07, Kok, Auke <auke-jan.h.kok@intel.com> wrote:
> Michel Lespinasse wrote:
> > (I've added the E1000 maintainers to the thread as I found the issue
> > seems to go away after I compile out that driver. For reference, I was
> > trying to figure out why I lose exactly 24 ticks about every two
> > seconds, as shown with report_lost_ticks. This is with a DQ965GF
> > motherboard with onboard E1000).
>
> that's perfectly likely. The main issue is that we read the hardware stats every
> two seconds and that can consume quite some time. It's strange that you are
> losing that many ticks IMHO, but losing one or two might very well be.
>

Why do you have to disable all interrupts?  Shouldn't it be sufficient
to disable interrupts on the e1000 only?

Lee
