Return-Path: <linux-kernel-owner+w=401wt.eu-S1751956AbXDHTku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbXDHTku (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 15:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbXDHTku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 15:40:50 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:13822 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbXDHTku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 15:40:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rlKQwy+UBmyQ3OX+98h+HY1Z2NnmyqMyq4nYfTUsvwqYxiT1TtnMWivEr1xQFZLVQb4JCvxQK7Uk3Go2JV9af2YdnMR8FOFU8wIkLqLDyXyM2Deog2dvBrNiH1fkK5qpjOHQ1xB99B4kOBZdHoF5DWPz+fJmJNr1PZEEhGAsM3k=
Message-ID: <a36005b50704081240w19ca19ffmc56688bd32450d42@mail.gmail.com>
Date: Sun, 8 Apr 2007 12:40:48 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: If not readdir() then what?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <46194260.3050900@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a36005b50704070957v2d2e6c4g5fac49b5ff1a5789@mail.gmail.com>
	 <20070407203633.GA21555@thunk.org>
	 <20070407233037.GA16508@infradead.org> <46193048.6000606@zytor.com>
	 <20070408184129.GA20871@lazybastard.org>
	 <20070408191955.GD29180@thunk.org> <46194260.3050900@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/8/07, H. Peter Anvin <hpa@zytor.com> wrote:
> More fundamentally, the telldir cookie should never be valid when
> applied to a different DIR * (even one that refers to the same directory.)

Don't worry about this.  This is clearly the semantics which was
always wanted. I've filed a defect report and it'll be handled.
