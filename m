Return-Path: <linux-kernel-owner+w=401wt.eu-S1756971AbYELRAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971AbYELRAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 13:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755423AbYELQ7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 12:59:43 -0400
Received: from el-out-1112.google.com ([209.85.162.177]:33225 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554AbYELQ7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 12:59:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qECrpPJhjDFnGfTfNXdRW471/LtBZjOuFQC7722LCtcoHYlQF2/8XKDUiDQlOjyS+h24wC861O3RA3/GJ8kDQEXaB6eOgrcY5CL3cVLDfVY36vlpIAvt5h2KN5RZXZ10frIBunAX7HcqdrckDIwAukdS67CUhtIZn90ZVIokjtU=
Message-ID: <8bd0f97a0805120959gee0f56bv746545c9b86ef7bd@mail.gmail.com>
Date: Mon, 12 May 2008 12:59:41 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH 1/1] [INPUT/KEYPAD] gpio keypad: Replace current blackfin specific pfbutton driver with kernel generic gpio key driver
Cc: "Bryan Wu" <cooloney@kernel.org>,
       "pHilipp Zabel" <philipp.zabel@gmail.com>,
       dbrownell@users.sourceforge.net, dmitry.torokhov@gmail.com,
       linux-kernel@vger.kernel.org,
       "Michael Hennerich" <michael.hennerich@analog.com>
In-Reply-To: <200805120954.06986.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1210587437-9751-1-git-send-email-cooloney@kernel.org>
	 <8bd0f97a0805120547g5c46973fl538ad18d81a4aebc@mail.gmail.com>
	 <386072610805120742k47e2433cxf7a1f8605fca47fb@mail.gmail.com>
	 <200805120954.06986.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 12:54 PM, David Brownell wrote:
> On Monday 12 May 2008, Bryan Wu wrote:
>  > Right. I mean the generic GPIO layer in Blackfin port, not the common code.
>  >
>  > And on the other hand, maybe there are also other hardware which has similar
>  > issue as Blackfin. So the common GPIO layer can take care of this, how
>  > do you think, David?
>
>  No; it's a Blackfin-specific design flaw, one that I've not seen
>  in any other chip's GPIO support.  So it should stay in the Blackfin
>  support code.  (Possibly even specialized for the specific chips
>  which have that flaw/erratum.)

afaik, it was a design flaw, not an erratum ... newer parts have the
situation rectified.  but Michael would be able to comment more
authoritatively on the topic.  we already have the logic to only make
the swap for parts that need it.
-mike
