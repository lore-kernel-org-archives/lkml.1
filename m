Return-Path: <linux-kernel-owner+w=401wt.eu-S1754943AbXEDOsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbXEDOsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 10:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755368AbXEDOsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 10:48:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:39931 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943AbXEDOsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 10:48:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=CpEqlL7IH4jP4WheZduAam3VSldo/mfNmiLIt5UM98KYBF4h2n6ziouVtqKxq8Tcips3Fy4FfqZ4IWPMIQEVrtRG7O8i89Bkq2cudfQTw4+DEqq+AUtEVmn0dnnLWkrFEIkHn/MR3R0en3PR5sRtHy0Ie9lyBANISif4GwOOQ88=
Message-ID: <463B47AF.4010503@gmail.com>
Date: Fri, 04 May 2007 16:48:15 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch]clarification of coding style regarding conditional statements
 with two branches
References: <200705040926.55257.oliver@neukum.org>
In-Reply-To: <200705040926.55257.oliver@neukum.org>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum napsal(a):
> Hi,
> 
> I suggest that the coding style should state that if either branch of
> an 'if' statement needs braces, both branches should use them.
> 
> 	Regards
> 		Oliver
> Signed-off-by: Oliver Neukum <oneukum@suse.de>
> ----
> 
> --- a/Documentation/CodingStyle	2007-04-20 13:08:17.000000000 +0200
> +++ b/Documentation/CodingStyle	2007-04-20 13:16:14.000000000 +0200
> @@ -160,6 +160,21 @@
>  25-line terminal screens here), you have more empty lines to put
>  comments on.
>  
> +Do not unnecessarily use braces where a single statement will do.
> +
> +if (condition)
> +	action();
> +
> +This does not apply if one branch of a conditional statement is a single
> +statement. Use braces in both branches.

Why, what's wrong with
if (condition) {
	do_this();
	do_that();
} else
	otherwise();

? It's more readable/nicer in my eyes than

> +if (condition) {
> +	do_this();
> +	do_that();
> +} else {
> +	otherwise();
> +}
> +

and not only in mine according to fast grep.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
