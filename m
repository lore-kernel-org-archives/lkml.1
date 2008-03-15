Return-Path: <linux-kernel-owner+w=401wt.eu-S1756940AbYCOBNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940AbYCOBNn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 21:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbYCOBNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 21:13:33 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:62625 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbYCOBNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 21:13:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fm4wPRyP+5frHL8TqH2Z34jsPNpegw/98/JK34smmY3cIaB/g3gl9rlcppf16/k4Fol5Z64x56bDzeB3dAl542cEVtgJ+dknl3hw2zgWm0Q97Nea0UCmcppxR14Kri5GvWphFzMQI7VCXFyE7XtXOFrglKFKo+4zZ4hU2jSzvgA=
Message-ID: <9a8748490803141813i32b5a411n3882ec0dac18891d@mail.gmail.com>
Date: Sat, 15 Mar 2008 02:13:29 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: [PATCH] ide-tape: Avoid potential null pointer dereference in idetape_abort_pipeline()
Cc: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Gadi Oxman" <gadio@netvision.net.il>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <87prtw2413.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LNX.1.00.0803150123450.29784@dragon.funnycrock.com>
	 <87prtw2413.fsf@saeurebad.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/03/2008, Johannes Weiner <hannes@saeurebad.de> wrote:
> Hi Jesper,
>
>
>  Jesper Juhl <jesper.juhl@gmail.com> writes:
>
>  > If a NULL 'new_last_stage' is passed to idetape_abort_pipeline() then
>  > we'll dereference a NULL pointer and go *boom*.
>  > The function does test for a null pointer, unfortunately it only does it
>  > after having already dereferenced it.
>
>
> Did you hit an oops because of this?
>

No, I did not.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
