Return-Path: <linux-kernel-owner+w=401wt.eu-S1760681AbXEUR3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760681AbXEUR3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 13:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755631AbXEUR3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 13:29:34 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:53865 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbXEUR3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 13:29:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Jz5yZ9ZrrOXCbVqJeZC5C+3i1Eify22fvefU+3IjH+6CfeV9V4tQzb7s8AhYZM2ekb72r/1/Oj8JJwgjdjhXpJ14PCK0wanZTtOX4gqQGWY2kn2zgKSTZpDINxhL79Fnjx0tYehaDuv8eexcsBktSKwh1lYf0kL9y3YlcUZTNeM=
Message-ID: <9e4733910705211029o177463aakaf476cd927359473@mail.gmail.com>
Date: Mon, 21 May 2007 13:29:32 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Dave Airlie" <airlied@gmail.com>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
In-Reply-To: <21d7e9970705211014j6eb59326u85f7347a3000f3d3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705171423.46748.jesse.barnes@intel.com>
	 <9e4733910705210901v5996cacas640f211404c519c6@mail.gmail.com>
	 <200705210914.22663.jbarnes@virtuousgeek.org>
	 <200705210934.58559.jbarnes@virtuousgeek.org>
	 <9e4733910705211005k761c976o1a6b270d87b49589@mail.gmail.com>
	 <21d7e9970705211014j6eb59326u85f7347a3000f3d3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/07, Dave Airlie <airlied@gmail.com> wrote:
> > 3) Eliminate the need for a root priv controlling process. Get rid of
> > the potential for a security hole.
>
> Stupid idea, we need something to control policy, this isn't going in
> the kernel, it can be a lot smaller than X and auditable.. sticking
> the DRI protocol in the kernel is just pointless..

Try to be more flexible with your thinking. It is ok to have a
transient, privileged command line app that does something like assign
an output to be under the control of a specific CRTC. I have no
problem with some of the IOCTLs requiring root priv.

What is not ok is to require a permanently running root priv process.
If the code is going to always be running make it as small as possible
and put it in the device driver.

-- 
Jon Smirl
jonsmirl@gmail.com
