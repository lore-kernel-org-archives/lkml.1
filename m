Return-Path: <linux-kernel-owner+w=401wt.eu-S1753935AbYDOGSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbYDOGSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 02:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751022AbYDOGSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 02:18:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:7321 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbYDOGSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 02:18:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ssdtq0pv5mvZ0bIoblA8dBUSIe3NpLvonZbdENJQIBoUdTcLCKqVH3j1FbLiFOckkNNxPxufYHy8Aa5SoNqriDxg+05jaGcjwYwTTTGwWhnxKgQeP4JFIA3NJFB9iIGWqlrliklEkfJv6n9vAhjqW9uNlP9G6hQc971mSqWvz4E=
Message-ID: <e2e108260804142318m19cf55c7p9973d3500de18120@mail.gmail.com>
Date: Tue, 15 Apr 2008 08:18:05 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] Replace completions with semaphores
Cc: "Peter Zijlstra" <peterz@infradead.org>,
       "Roland Dreier" <rdreier@cisco.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Matthew Wilcox" <matthew@wil.cx>, "Ingo Oeser" <ioe-lkml@rameria.de>,
       "Daniel Walker" <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@osdl.org>
In-Reply-To: <4803AD91.5020001@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080411210022.GJ11962@parisc-linux.org>
	 <20080412204748.GN11962@parisc-linux.org>
	 <20080413070833.GC19773@elte.hu>
	 <20080413125758.GQ11962@parisc-linux.org>
	 <20080414153928.GA22259@elte.hu> <adafxtoqvgh.fsf@cisco.com>
	 <1208190749.7375.10.camel@twins> <87d4osuy6r.fsf@basil.nowhere.org>
	 <1208195673.7164.2.camel@twins> <4803AD91.5020001@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 9:16 PM, Andi Kleen <andi@firstfloor.org> wrote:
>  For me it sounds like you just want to rename semaphores to some other
>  name that people don't use them for normal locking?

Would it really be a good idea to give a synchronization concept that
behaves exactly like a semaphore another name than "semaphore" ? The
semaphore concept is well known and is taught in every computer
science course.

Bart.
