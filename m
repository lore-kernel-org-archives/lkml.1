Return-Path: <linux-kernel-owner+w=401wt.eu-S1757717AbXKNMep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717AbXKNMep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 07:34:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754681AbXKNMeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 07:34:37 -0500
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:46313 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754312AbXKNMeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 07:34:36 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=p+OQFFTcMpAWd+R/1E7KmnRL0KpC2WZNuDITbkIVm6tPi7u9mxwZ3AhlwaCiobUSoKUz/C0l4u+oQncfLBlMYy9e+xmnfILabPEvwP+9/ZI4PoRwBGh33RqNkmtFQo7MWxpcmNuw93nTGrZuDzGlrH72+VOJrLy9LkDJaW5f0os=  ;
X-YMail-OSG: AMSzWtsVM1mQmkYYD5UcIdD2SQgDNafBX1diUrdNH1LHnDBlhnJIF2AmV40R8xgVkU7ac687gQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Miller <davem@davemloft.net>
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Date: Wed, 14 Nov 2007 11:28:59 +1100
User-Agent: KMail/1.9.5
Cc: paulus@samba.org, hch@infradead.org, akpm@linux-foundation.org,
       gregkh@suse.de, mucci@cs.utk.edu, eranian@hpl.hp.com, wcohen@redhat.com,
       robert.richter@amd.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org
References: <18234.57272.590960.860941@cargo.ozlabs.ibm.com> <18234.58380.400222.329961@cargo.ozlabs.ibm.com> <20071114.040758.101673950.davem@davemloft.net>
In-Reply-To: <20071114.040758.101673950.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711141128.59758.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 November 2007 23:07, David Miller wrote:
> From: Paul Mackerras <paulus@samba.org>
> Date: Wed, 14 Nov 2007 23:03:24 +1100
>
> > You're suggesting that the behaviour of a read() should depend on what
> > was in the buffer before the read?  Gack!  Surely you have better
> > taste than that?
>
> Absolutely that's what I mean, it's atomic and gives you exactly what
> you need.
>
> I see nothing wrong or gross with these semantics.  Nothing in the
> "book of UNIX" specifies that for a device or special file the passed
> in buffer cannot contain input control data.

True, but is it now any so different to an ioctl?
