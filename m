Return-Path: <linux-kernel-owner+w=401wt.eu-S1764897AbZDCWTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764897AbZDCWTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 18:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754398AbZDCWTC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 18:19:02 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:9502 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbZDCWTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 18:19:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UJfQoBMkMiLfNBjxSiwDOR4e3GjqhbHFEkKTDTw4uv0qS1dIXQzo4U5oprT/d2a5U5
         06pH0INmzBUmPX/v2Hp5/MdXdM4+Lnr7S02GFFgfPMvviaASh7RfA/odSoF8CHtBSAec
         0h/q8a6UGP/NLJ1D0wiuFKBwGutf0DT9QaHQQ=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0904031453170.4329@chino.kir.corp.google.com>
References: <f3177b9e0904031302p8aef826u1874a8b9d9af0840@mail.gmail.com>
	 <87vdpljuqi.fsf@basil.nowhere.org>
	 <alpine.DEB.2.00.0904031438540.3646@chino.kir.corp.google.com>
	 <20090403215351.GF11935@one.firstfloor.org>
	 <alpine.DEB.2.00.0904031453170.4329@chino.kir.corp.google.com>
Date: Fri, 3 Apr 2009 15:18:58 -0700
Message-ID: <86802c440904031518l155d9f9bj14a120a89bde6a7a@mail.gmail.com>
Subject: Re: Off topic: Numactl "distance" wrong
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Chris Worley <worleys@gmail.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 3, 2009 at 2:54 PM, David Rientjes <rientjes@google.com> wrote:
> On Fri, 3 Apr 2009, Andi Kleen wrote:
>
>> That's the same really. Think about it. No SLIT on a NUMA system is a wrong
>> SLIT.
>>
>
> Unless each node really is symmetrically distant from each other node, in
> which case the distance is reported correctly as a result of the differing
> pxms.
>

when ACPI is used, first PXM show up in SRAT table will become node0...
so you already have node_to_pxm mapping.

YH
