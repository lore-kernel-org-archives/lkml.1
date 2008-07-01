Return-Path: <linux-kernel-owner+w=401wt.eu-S1755769AbYGAMIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbYGAMIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 08:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbYGAMIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 08:08:11 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:36723 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbYGAMIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 08:08:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Amij4GCOlBj6Tan92mea79qsnYKuaXi+USGJCx2ZvfJJsdA8a+QGR+g4T41KysO8WN
         kmi+rgv5wDQc2v6KlPBfP5n8nfLel0JNYtEceujmL9q5fmP265ZmUXpa958AQkhDys+L
         bKGfUlrkuADVpEHhzpMfX+8YLQLYDHxHFy93k=
Message-ID: <84144f020807010508o1332fab8rfd6bd050a6e56eb9@mail.gmail.com>
Date: Tue, 1 Jul 2008 15:08:09 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: kmemcheck detected possible information leak to userspace?
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>, netdev@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <87skutu8pw.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807010216k11a60382xf7a27b4b27f0819@mail.gmail.com>
	 <20080701102459.GB30248@2ka.mipt.ru>
	 <19f34abd0807010352t264fda16g826912a857e88140@mail.gmail.com>
	 <87skutu8pw.fsf@basil.nowhere.org>
X-Google-Sender-Auth: 2c0e0c73d54ebb87
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

"Vegard Nossum" <vegard.nossum@gmail.com> writes:
>> But there is one thing I forgot: Is this memory initialized by DMA? If
>> so, the warning is bogus and I will go hide in shame.

On Tue, Jul 1, 2008 at 2:47 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Yes it is.
>
> [btw that was something I noted during the initial review and was then
> ridiculed for]

Yes, you pointed that out but we sure as hell didn't ridicule you for
it. I even explicitly said that we're probably missing kmemcheck
annotations from other similar places as well (not just networking).
