Return-Path: <linux-kernel-owner+w=401wt.eu-S1755933AbZKQLyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbZKQLyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 06:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755471AbZKQLyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 06:54:36 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:50603 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754988AbZKQLyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 06:54:35 -0500
X-Greylist: delayed 313 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Nov 2009 06:54:34 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wW9c3/UzsmlB6NgRJb/cQxUUDfb9EiW0pYQPbPT7AUiMqBJYGy7Aj5CKP1Q47PCZMS
         2jeVHbUxu2CowEm2AwDNZlFgUO+WtVWJ4CLGvjavQKsCHJ8uRQAAMaPdupLYSc8oNf6D
         hnPOgekBq9s8UMlV0TPgI5zeEi5WRDX0fGQi0=
Date: Tue, 17 Nov 2009 14:49:22 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: joe@perches.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl.c: Change a .proc_handler = proc_dointvec to
Message-ID: <20091117114922.GA1657@x200>
References: <20091115105957.GA1935@x200>
 <m1ws1pfpau.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ws1pfpau.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 01:55:53AM -0800, Eric W. Biederman wrote:
> Alexey Dobriyan <adobriyan@gmail.com> writes:

> >     net: '&' redux
> >     
> >     I want to compile out proc_* and sysctl_* handlers totally and
> >     stub them to NULL depending on config options, however usage of &
> >     will prevent this, since taking adress of NULL pointer will break
> >     compilation.
> 
> I just experimented with this and found that at present a number of
> the proc handlers wrap functions like proc_dointvec, so it does not work.
> 
> Did you have a plan for those?

Of course, net/ was just first big step.
