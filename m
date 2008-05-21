Return-Path: <linux-kernel-owner+w=401wt.eu-S937306AbYEUVQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937306AbYEUVQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 17:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937899AbYEUVPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 17:15:22 -0400
Received: from gv-out-0910.google.com ([216.239.58.191]:29358 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937608AbYEUVPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 17:15:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=U0qCjuRo3Foayv+2uHo6Nal/2Hz30LT2via8Ms+GNYXX4pElWw1Si14gpqnqzvR4oCt9nGqKA6qo8GPVJem6u95JoY0OqAbKPFIijHOoU84IHrqavb4tAnokmBpkxbFBxeryrSVlOc0yhHFcOoQj01GCPWUU4dann+BaOCgvOqw=
Message-ID: <9a8748490805211415x4f81fb71i7a04ff8d2c42d1b9@mail.gmail.com>
Date: Wed, 21 May 2008 23:15:17 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: mark <markkicks@gmail.com>
Subject: Re: fork: Resource temporarily unavailable / cant start new threads
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <82fa9e310805211408o65b49923jd9bf4a6c89b97c30@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <82fa9e310805201126q45e869bdub74a947068fe612a@mail.gmail.com>
	 <20080521132845.72db5748.randy.dunlap@oracle.com>
	 <82fa9e310805211339o3090e0d0le8503051d3e0aa38@mail.gmail.com>
	 <48348AFA.1070900@oracle.com>
	 <82fa9e310805211408o65b49923jd9bf4a6c89b97c30@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/21 mark <markkicks@gmail.com>:
<snip>
>>> my webserver is now throwing this error:
>>>
>>> setuid(500) failed (11: Resource temporarily unavailable)
>>
>> That's all of the useful information??
>
> Yes. i get this error  when i restart the web server. if i kill all
> other apps, and then start it again it starts fine.
>
> this is the complete error message,
> 2008/05/21 08:02:19 [emerg] 30558#0: setuid(500) failed (11: Resource
> temporarily unavailable)
> 2008/05/21 08:02:19 [alert] 30557#0: worker process 30558 exited with
> fatal code 2 and can not be respawn

What about if you run 'dmesg'? are there any clues in that output?
any kernel stack traces? error messages? warnings? anything out of the
ordinary?

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please http://www.expita.com/nomime.html
