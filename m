Return-Path: <linux-kernel-owner+w=401wt.eu-S1765321AbXGSNa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765321AbXGSNa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755468AbXGSNav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:30:51 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:28030 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbXGSNar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:30:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JkBQzgVke4dKj+2fc1JHa2rnZyRO3vR1y5laVN7LxqT7GGrjEg/C4KxZftBOlmtOrzqgg2PGO339YfAgvFyctiLcbUjcmlSS4faz3ZHzQPTR9clI9Eoo5YVEq7HLerqTlTz1RAQZCg58dx1ZyWnkj/eq3lqn0bW69F/mMQB7cQQ=
Message-ID: <7b69d1470707190630r322eb8bfka7b0dbd1677b7396@mail.gmail.com>
Date: Thu, 19 Jul 2007 08:30:44 -0500
From: "Scott Preece" <sepreece@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH try #3] security: Convert LSM into a static interface
Cc: "James Morris" <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
       "Christian Ehrhardt" <lk@c--e.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Chris Wright" <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       "Stephen Smalley" <sds@tycho.nsa.gov>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <20070719141535.4a9c8581@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Line.LNX.4.64.0707141233490.26711@d.namei>
	 <20070718183503.541026f8.akpm@linux-foundation.org>
	 <20070719073948.GI18840@lisa.in-ulm.de>
	 <20070719122424.GA5186@vino.hallyn.com>
	 <Line.LNX.4.64.0707190832290.4303@d.namei>
	 <7b69d1470707190556n78e52232y7dfea1fd6f47ced@mail.gmail.com>
	 <20070719141535.4a9c8581@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/19/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
> > Please distinguish between "cater to" and "support". If the kernel
> > didn't worry about supporting out-of-tree code, then why would there
> > be loadable module at all?
>
> Memory usage, flexibility, debugging.
>
> Module support was not added for external modules.
>

Code that is being debugged is, often [usually, I hope], out-of-tree
code, though it may be aimed at future inclusion.

However, I do agree that there is value to having loadable modules for
in-tree functionality, too.

scott
-- 
scott preece
