Return-Path: <linux-kernel-owner+w=401wt.eu-S1755275AbZGVXVD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbZGVXVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 19:21:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754788AbZGVXVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 19:21:03 -0400
Received: from smtp-out.google.com ([216.239.45.13]:55135 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614AbZGVXVB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 19:21:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=nfFnf+3VcCSyucs2A8wO/U8Dw9yqKmrjyV46B3uw/MWyl+ELT/A2oEO8xLJ0Qtb66
	zGPTIRHv4EkmMVqAASjCA==
MIME-Version: 1.0
In-Reply-To: <1248299464.24021.334.camel@nimitz>
References: <20090721220017.60A219D3@kernel>
	 <2f86c2480907221357j5a09fd9au890f815db3750187@mail.gmail.com>
	 <1248299464.24021.334.camel@nimitz>
Date: Wed, 22 Jul 2009 16:20:57 -0700
Message-ID: <2f86c2480907221620u6da3a8e3h8273f6a9ee156f86@mail.gmail.com>
Subject: Re: [RFCv2][PATCH] flexible array implementation
From: Benjamin Blum <bblum@google.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, menage@google.com,
       vda.linux@googlemail.com, mikew@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 2:51 PM, Dave Hansen<dave@linux.vnet.ibm.com> wrote:
> On Wed, 2009-07-22 at 13:57 -0700, Benjamin Blum wrote:
>> Does the array automatically grow if you give it more elements than
>> you tell it it can have?
>
> The only limits it has or enforces are the structural and architectural
> ones dictated by the layout.
>
>> How about a resize() function that can be
>> used to either grow or shrink the array?
>
> I think growing is out of the question.  It has a fixed maximum size
> already.  As for shrinking, there's probably a use case for when
> something is large, then shrinks back down.  But, I think I'd want to
> see a user for it, otherwise I'm just guessing at it too much.
>
> -- Dave
>
>

Check out the reallocate logic in pidlist_uniq from my patch (the
series you linked).
