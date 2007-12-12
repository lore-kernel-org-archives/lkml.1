Return-Path: <linux-kernel-owner+w=401wt.eu-S1759246AbXLLKWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246AbXLLKWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 05:22:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758228AbXLLKW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 05:22:27 -0500
Received: from web52902.mail.re2.yahoo.com ([206.190.49.12]:36645 "HELO
	web52902.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758130AbXLLKW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 05:22:26 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=WX33+ghK6K0tL2AizHFTRgu54eMACA8U5SUyT4Q6pmT24fyNeXljQsQeauxInsnnt4OtngGFDesgfJZBTr8fQFn5kn12new/59bnsvfrVydzyHJJkFCpfhYmF8VsnOtasg6DP3lRplTPrtt9SOoxGYTaxdJ/lzAV9R+DLWQ4/Vk=;
X-YMail-OSG: X.ES1k8VM1lg3aFnxef9sAltXVb6NfjYN2hwY9.VzDwKnA.v3MIO2SRHV5OqbgGm9IOYbK_E3P_9yb6NHmx6NnLQuFL5sA3l0Rt2r07nDUxkcsDhwSKPMJi_wowghiGR2_.gvJu2LWqltOlIWCKcmLwE8A--
Date: Wed, 12 Dec 2007 10:22:25 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [2.6.23.9] hostap_plx locks up PC when reading PCI I/O memory
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dcbw@redhat.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
In-Reply-To: <20071212020325.96dbf41b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <293380.40997.qm@web52902.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Andrew Morton <akpm@linux-foundation.org> wrote:
> hm.  Could be some platform thing.  Strange.  It might be worth checking
> around that ioremap, make sure that the value which it returned is the one
> which is being used in the function-which-hangs, etc.

OK, not difficult to try. (This is x86, BTW.) But I'm still baffled as to precisely why it is
hanging. Is it waiting for a value from the PCI bus that never appears, or something? Are there
any other PCI-related tests that I can do to check that the device has been initialised correctly
on the bus, please?

> hostap_plx.c first appeared in 2.6.14.

OK, I can build one of those kernels. Before then, I think that hostap was provided as an external
source package.

Cheers,
Chris


      __________________________________________________________
Sent from Yahoo! Mail - a smarter inbox http://uk.mail.yahoo.com

