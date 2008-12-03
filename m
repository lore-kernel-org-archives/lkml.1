Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbYLCEf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbYLCEf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 23:35:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbYLCEfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 23:35:46 -0500
Received: from an-out-0708.google.com ([209.85.132.248]:59647 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbYLCEfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 23:35:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nae1fjI6wuX5kgjAqj+VT0nD+AP8pNPYMlvLrqmqFCZtIH+tAbPiuSe7c1hEnzjWyP
         RJXSeTvamFBdb85ysCwjWlU3TrEL+g4ITbHVW5uVE3uJjBDxq/aKNjViJuvW/sI5Rk7W
         rgxWJAAXufLyRFN3hHEl58fVTyXOSaoghl5Hc=
Message-ID: <804dabb00812022035k1876a521qa41cd4634b70f9a2@mail.gmail.com>
Date: Wed, 3 Dec 2008 12:35:43 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: "Geoffrey McRae" <geoff@rabidhost.com>
Subject: Re: New Security Features, Please Comment
Cc: Valdis.Kletnieks@vt.edu, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1228276959.6679.27.camel@lappy.spacevs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1228260494.24232.21.camel@compy.ivent.com.au>
	 <20081203005338.6472db7a@lxorguk.ukuu.org.uk>
	 <1228268657.6679.4.camel@lappy.spacevs.com>
	 <73639.1228272932@turing-police.cc.vt.edu>
	 <1228276959.6679.27.camel@lappy.spacevs.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2008 at 12:02 PM, Geoffrey McRae <geoff@rabidhost.com> wrote:
>
> My initial concept is to implement a HTTP server that is designed from
> the ground up to use this new functionallity. Each server that has been
> pre-forked will just sit there until the parent sets its uid/gid and
> hands it the request to handle.
>

I think the above is the core issue - you have something privileged to
be executed.   So why not execute it in a small, code-verifiable
implementation, just like the Privilege Separation idea of SSH?

http://www.citi.umich.edu/u/provos/papers/privsep.pdf

Everything is done in userspace.   SInce the privileged component is
small, it is easy to verify for correctness.   The rest execute with
lesser privilege.

Recently, the hypervisor has been used to implement this verifiable
source code concept:   see:

http://www.ghs.com/news/20081117_integrity_EAL6plus_security.html

where GreenHill achieved EAL6 certification - as it built its entire
kernel on top of the hypervisor.   (called Separation Kernel,
conceptually similar to that of Privilege Separation in SSH).

Just my 2cts :-).

-- 
Regards,
Peter Teoh

Ernest Hemingway - "Never mistake motion for action."
