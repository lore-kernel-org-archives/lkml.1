Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbYGCTUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbYGCTUK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 15:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbYGCTT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 15:19:57 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:50238 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbYGCTT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 15:19:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bVo0RmvFKt7IzeU9J9YGGmwKz/V0XQT0ggJRtuecny0jVFAapfrosQtafkRkyqq+9l
         Vx2vZA8ML/+Q/wAGpbJzaEOGvidHjTz82qxLUod4bynk0jmS7PXPJ5Y9fCLrPpN0JZXX
         9HW/GNmq7naj7uKjuii0lybRHsV732vMlGwMM=
Message-ID: <86802c440807031219w1355c31axb4daf78f3ec626ed@mail.gmail.com>
Date: Thu, 3 Jul 2008 12:19:53 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [Xen-devel] Re: [PATCH 00 of 36] x86/paravirt: groundwork for 64-bit Xen support
Cc: "Ingo Molnar" <mingo@elte.hu>, "Nick Piggin" <npiggin@suse.de>,
       "Mark McLoughlin" <markmc@redhat.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       "Eduardo Habkost" <ehabkost@redhat.com>,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Stephen Tweedie" <sct@redhat.com>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440807031151o577d001g3e72bae3aa88df25@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <486539A3.3030102@goop.org> <20080701092152.GA18918@elte.hu>
	 <486A57C8.3010008@goop.org> <20080701203123.GG4896@elte.hu>
	 <20080703091053.GA1883@elte.hu>
	 <86802c440807031120o6e87459em8c4f239eb1a2507c@mail.gmail.com>
	 <486D19B1.1080402@goop.org>
	 <86802c440807031130keada2fbva256f2efe3c4801@mail.gmail.com>
	 <486D1D40.9050309@goop.org>
	 <86802c440807031151o577d001g3e72bae3aa88df25@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 3, 2008 at 11:51 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Thu, Jul 3, 2008 at 11:41 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
..
>> I modified the vmemmap code so it would create 4k mappings if PSE isn't
>> supported.  Did I get it wrong?  It should have no effect when PSE is
>> available (which is any time you're not running under Xen).
>>
>
> it could be address continuous checkup for printout in
> vmemmap_populated has some problem...

you moved p_end = p + PMD_SIZE before...

if (p_end != p || node_start != node) {

YH
