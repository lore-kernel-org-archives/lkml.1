Return-Path: <linux-kernel-owner+w=401wt.eu-S1754252AbZGVVzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbZGVVzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 17:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754095AbZGVVzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 17:55:41 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:51137 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbZGVVzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 17:55:41 -0400
Subject: Re: [RFCv2][PATCH] flexible array implementation
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Benjamin Blum <bblum@google.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, menage@google.com,
       vda.linux@googlemail.com, mikew@google.com
In-Reply-To: <2f86c2480907221357j5a09fd9au890f815db3750187@mail.gmail.com>
References: <20090721220017.60A219D3@kernel>
	 <2f86c2480907221357j5a09fd9au890f815db3750187@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 22 Jul 2009 14:51:04 -0700
Message-Id: <1248299464.24021.334.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-22 at 13:57 -0700, Benjamin Blum wrote:
> Does the array automatically grow if you give it more elements than
> you tell it it can have?

The only limits it has or enforces are the structural and architectural
ones dictated by the layout.  

> How about a resize() function that can be
> used to either grow or shrink the array?

I think growing is out of the question.  It has a fixed maximum size
already.  As for shrinking, there's probably a use case for when
something is large, then shrinks back down.  But, I think I'd want to
see a user for it, otherwise I'm just guessing at it too much.

-- Dave

