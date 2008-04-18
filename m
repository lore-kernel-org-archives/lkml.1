Return-Path: <linux-kernel-owner+w=401wt.eu-S1755042AbYDRL4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbYDRL4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 07:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbYDRL4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 07:56:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:63485 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbYDRL4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 07:56:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Kb96djIJFBuSjvgzYBXZ5xp3xlM8W8q9Yphr5Itb5y+l3049/rWTZUka3X0/fW7i/RwvGJ8nH3HRUT9ehs07szfewQ4YRe3wy+G0KK08fa4GNxTYGaZKpA7WdAWlQBWwqrXUoR7Zd7S2194bLzrznx25Z1WGpr0FJm2WX5WetAA=
Message-ID: <e2e108260804180456h56d5d613ya38ea32584c998a0@mail.gmail.com>
Date: Fri, 18 Apr 2008 13:56:09 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Marc Perkel" <mperkel@yahoo.com>
Subject: Re: AMD Quad Core clock problem?
Cc: "Chris Snook" <csnook@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <298557.12633.qm@web52504.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e2e108260804162317s5162a6cds151bba6abf988921@mail.gmail.com>
	 <298557.12633.qm@web52504.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 8:03 PM, Marc Perkel <mperkel@yahoo.com> wrote:
>
>  Thanks Bart - that seems to have worked. A value of
>  10025 seems to get it close enough for NTPD to lock
>  on. I'm using tickadj.
>
>  So - the question is - is this a kernel bug not
>  calibrating quad core phenoms right or do I just have
>  a bad motherboard?

That's a very good question. I don't have enough knowledge of AMD quad
cores and the motherboards they are used in to answer this question.
There should be a kernel maintainer that is able to answer this
question though.

Last year I fixed a similar issue for PPC32. See also
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=0fbbeba2427a842a1a4ac9f379ca2ca37ea907eb;hp=6e1af384f1c1742ae6d86bbf779d4fa020c509bc.

Bart.
