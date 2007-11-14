Return-Path: <linux-kernel-owner+w=401wt.eu-S1764026AbXKNX2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764026AbXKNX2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 18:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755736AbXKNX2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 18:28:03 -0500
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:26128 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753086AbXKNX2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 18:28:01 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=6aoXnp1MEyTVRH0QyWQCaksCY28ElzfSWI3buwjF+aDnjbowcKb5FviVBkkipO4RMcI87gDmTZIepxtoq/JdVMfF9ewE7A+N/MwPXuw3yOMd+wLfUJC5oZCC7CUfrHZhrCmX9G0pb2WPpA9zHbw9OJOtEG5PjNWOZasnBGjseag=  ;
X-YMail-OSG: ycVBJA4VM1lfMQS3fCAEdtHlSzFDBMEFVsu.qkdIyM3xMmsOp.X0mT.r9lJ4B8uADQIl3Qxe8Q--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Date: Wed, 14 Nov 2007 22:03:23 +1100
User-Agent: KMail/1.9.5
Cc: Paul Mackerras <paulus@samba.org>, David Miller <davem@davemloft.net>,
       hch@infradead.org, akpm@linux-foundation.org, gregkh@suse.de,
       mucci@cs.utk.edu, eranian@hpl.hp.com, wcohen@redhat.com,
       robert.richter@amd.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org
References: <20071114.031216.11725447.davem@davemloft.net> <200711142117.56352.nickpiggin@yahoo.com.au> <473B7D07.6030901@redhat.com>
In-Reply-To: <473B7D07.6030901@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711142203.23982.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 November 2007 09:56, Chuck Ebbert wrote:
> On 11/14/2007 05:17 AM, Nick Piggin wrote:
> > But in general, for special files, I guess the response is usually
> > some structured data (that is not visible at the syscall layer).
> > So I don't see a big problem to have a similarly arbitrarily
> > structured request.
>
> IOW, an ioctl.

In the same way a read of structured data from a special file
"is an" ioctl, yeah. You could implement either with an ioctl.

The main difference is they have more explicitly typed interfaces
Whether that's enough argument (and if Paul's proposal is widely
usable enough) is another question. Which I won't try to answer.
