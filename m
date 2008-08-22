Return-Path: <linux-kernel-owner+w=401wt.eu-S1761465AbYHVCdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761465AbYHVCdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 22:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbYHVCcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 22:32:50 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:38538 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753216AbYHVCct (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 22:32:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=bsn14tVoJzsjmc/ePQxARk40Ae1F/XPAae3C4WrPdNIgX1FhqDgmpV/XLo8GehHFGoP/kQTVBSird2/plZO9Uf5uXw4fNRt+Lc9FrUO0IMV56jjkX0exFJANZWhxbGnTWAgCgLtpefZ9gr1liuT1/7K0lMaCELW12E4u8oG2Wdk=  ;
X-YMail-OSG: XfnNkw8VM1k8BHYIVc50qgI55_C0bQcL06Om6PA5uXvgqum8N7ovnS.DAxzHlaWiIzQgtIkOljpCmZTxRRiY_jCltSYZRvhp3UeO9bk57_0uNuAXjtIsV.BBBqg.wi9viMs-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Jared Hulbert" <jaredeh@gmail.com>
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
Date: Fri, 22 Aug 2008 12:32:41 +1000
User-Agent: KMail/1.9.5
Cc: carsteno@de.ibm.com, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?utf-8?q?J=C3=B6rn?= Engel" <joern@logfs.org>, tim.bird@am.sony.com
References: <48AD00C4.6060302@gmail.com> <200808212043.51209.nickpiggin@yahoo.com.au> <6934efce0808210713m220d2a6cje06a2dc51c4a857a@mail.gmail.com>
In-Reply-To: <6934efce0808210713m220d2a6cje06a2dc51c4a857a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808221232.42115.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 August 2008 00:13, Jared Hulbert wrote:
> > Agreed. I haven't had a good look through it yet, but at a glance it
> > looks pretty neat. The VM side of things looks pretty reasonable
> > (I fear XIP faulting might have another race or two, but that's a
> > core mm issue rather than filesystem specific).
>
> How might I design a test to flush those bugs out?  We haven't seen any.

Not quite sure yet. I just fixed a couple of easy ones, but there
could be some more lurking. Don't be too worried about it yet, I
was just musing to myself there really :)
