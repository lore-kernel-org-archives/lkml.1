Return-Path: <linux-kernel-owner+w=401wt.eu-S1764099AbXGFRaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764099AbXGFRaj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 13:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762173AbXGFRaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 13:30:22 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:55735 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762031AbXGFRaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 13:30:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=BlTs4PaB0IAMtI8nSN/XO+05br8Sp7pKF8QZfSiTXmBsOjijjNcgpiHmsS4gViDv1RzGhQ31fAFqz1SS0OkPCYG7g45L/+VkinnvXU8LMN0g8VUbj9yXNuexJHpuAR5bzSokWQXMLKoGWaYIAJBGxo04ZhLDZX4Ap37yhav7ROU=
Message-ID: <a71bd89a0707061030s15572cj49cb748bf274593b@mail.gmail.com>
Date: Fri, 6 Jul 2007 10:30:19 -0700
From: "Dan Kegel" <dank@kegel.com>
To: "Jeff Dike" <jdike@addtoit.com>
Subject: Re: Valgrinding the kernel?
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       "Robert Walsh" <rjwalsh@durables.org>
In-Reply-To: <20070706172513.GD10670@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a71bd89a0707052114u28fed408h4326913c502a43ac@mail.gmail.com>
	 <468DD6A5.4020705@goop.org>
	 <20070706172513.GD10670@c2.user-mode-linux.org>
X-Google-Sender-Auth: 551811fbcd25713d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/6/07, Jeff Dike <jdike@addtoit.com> wrote:
> UML is cloning a thread in order to test the host's ptrace.  However,
> it looks like valgrind is branching to 0x9 for some reason.
>
> This particular bit is going to be problematic for other reasons, but
> if valgrind ever looks like it has a chance of working, I can work
> around that in UML.

Could you give it a shot?   Maybe the problems after
that will be more pedestrian.  I'm willing to focus a little
effort on this.

Thanks,
Dan
