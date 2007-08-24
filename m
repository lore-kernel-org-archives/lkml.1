Return-Path: <linux-kernel-owner+w=401wt.eu-S932265AbXHXJAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265AbXHXJAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 05:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761337AbXHXJAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 05:00:46 -0400
Received: from ag-out-0708.google.com ([72.14.246.242]:51088 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761334AbXHXJAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 05:00:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rsSjb0WQ7oa/Qaiv7aoDoGmx+kHOZ3phi+ub+zqAEEYVhGGNaj0zM72ulAnUGNOKz3utBhQWQssNMrd9OK8RcvVFS/piltKng6AYB0vDFQE9nYKp3PlhcubhkzA3fVBjnzRKuKB5DXrzErekugwWCp0kkWQoM1wjl5Xl2ACfAKw=
Message-ID: <9a8748490708240200w3df4756fpd32e5b84dcb7f18a@mail.gmail.com>
Date: Fri, 24 Aug 2007 11:00:43 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: [PATCH 20/30] scsi: In the Advansys driver, do not cast allocation function return values
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org,
       "James Bottomley" <James.Bottomley@steeleye.com>, linux@connectcom.net
In-Reply-To: <20070824020349.GS9163@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
	 <82de4728edd63551c2c8a2fff0350f0917ed73a5.1187912217.git.jesper.juhl@gmail.com>
	 <20070824020349.GS9163@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/08/07, Matthew Wilcox <matthew@wil.cx> wrote:
> On Fri, Aug 24, 2007 at 02:16:12AM +0200, Jesper Juhl wrote:
> > There's no reason to cast void pointers returned by the generic
> > memory allocation functions.
>
> I think I fixed all these already; please check scsi-misc.
>
I just checked out the latest scsi-misc-2.6 tree and it does indeed
look like these have already been dealt with.
Sorry about the noise.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
