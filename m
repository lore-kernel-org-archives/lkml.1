Return-Path: <linux-kernel-owner+w=401wt.eu-S1756328AbYAHWyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbYAHWyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbYAHWyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:54:01 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:59423 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbYAHWyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:54:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XodQQps9C1z0fZi4RrF3lm4fiCSwkciDm56LXOEcekFtXq5+8+/r228SmNM1pj1w5HlAhyoX6RTjANADEqur9fMazdrW8VboU+2NVhLAkdosUuN2UxGRXZncodTI0+fUVssFnusfvExLGDJif6nbBr2NexQzvRpHnGEQ7vDrEUU=
Message-ID: <7b9198260801081453s198af7efycc7c35668c65eaf1@mail.gmail.com>
Date: Tue, 8 Jan 2008 22:53:59 +0000
From: "Tom Spink" <tspink@gmail.com>
To: "Rick Jones" <rick.jones2@hp.com>
Subject: Re: AF_UNIX MSG_PEEK bug?
Cc: "Brent Casavant" <bcasavan@sgi.com>, netdev@vger.kernel.org,
       "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <4783FBD6.1000004@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.BSF.1.00.0801081556580.24286@pkunk.americas.sgi.com>
	 <4783FBD6.1000004@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2008, Rick Jones <rick.jones2@hp.com> wrote:
> Potential bugs notwithstanding, given that this is a STREAM socket, and
> as such shouldn't (I hope, or I'm eating toes for dinner again) have
> side effects like tossing the rest of a datagram, why are you using
> MSG_PEEK?  Why not simply read the N bytes of the message that will have
> the message length with a normal read/recv, and then read that many
> bytes in the next call?
>
> rick jones
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Hi,

Where in the code is the message length being sent across the socket?

-- 
Regards,
Tom Spink
University of Edinburgh
