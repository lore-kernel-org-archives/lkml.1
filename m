Return-Path: <linux-kernel-owner+w=401wt.eu-S1756416AbXHXKb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416AbXHXKb5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 06:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbXHXKbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 06:31:48 -0400
Received: from server001.webpack.hosteurope.de ([80.237.130.9]:55745 "EHLO
	server001.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753015AbXHXKbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 06:31:47 -0400
From: Andi Drebes <lists-receive@programmierforen.de>
To: postfail@hushmail.com
Subject: Re: Ideas on column length in kernel "problem"?
Date: Fri, 24 Aug 2007 12:31:52 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20070823035442.6FD0DDA81F@mailserver7.hushmail.com>
In-Reply-To: <20070823035442.6FD0DDA81F@mailserver7.hushmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708241231.52767.lists-receive@programmierforen.de>
X-bounce-key: webpack.hosteurope.de;lists-receive@programmierforen.de;1187951507;327ae45b;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Many free (and not-free) mail clients wordwrap.  Hushmail wraps at 
> 68 (verified), Yahoo has options to wrap at a max of 99, and Gmail 
> was somewhere around 85-90 as I recall.  Not sure on other free / 
> inexpensive clients.  
It happens so often that people send mangled patches that it might be useful 
to create a wiki page or something with the most common email clients and a 
sample configuration that prevents them from mangling patches. Maybe somebody 
feels like doing so in his / her spare time.
 
> However, several code modules have code lines with column lengths 
> well over 80 (the worst I have seen was 211).  This prevents people 
> with "minimal function" email clients (I'm being generous) from 
> making changes in the area of these long code lines, or from even 
> submitting fixes for the line length problem in modules themselves.
I think this is also a matter of conding style. Documentation/CodingStyle 
says:

"The limit on the length of lines is 80 columns and this is a hard limit."

So actually there shouldn't be any line longer than that. Perhaps it would be 
nice to create a patches that shorten the lines and to send them to the 
kernel-janitors ml.

<snip>
> Note -- I am well aware that us 'poor users' could just 'get a real 
> email service', and if anyone knows of a free/inexpensive mail 
> client that will be able to handle the wordwrap requirements for 
> the current state of the linux tree please advise.
see above.

	Cheers,
		Andi
