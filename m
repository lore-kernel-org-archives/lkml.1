Return-Path: <linux-kernel-owner+w=401wt.eu-S1161513AbXDXCzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161513AbXDXCzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 22:55:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161542AbXDXCzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 22:55:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:25272 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161513AbXDXCzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 22:55:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=n3hH0902PvYrmNNRCHHkdnxY32kC0mbj5Yf+rR8ocS9V0gThicINmcFfTP4sBYpEsKxGO/gdXSVqCwT+YKq79C38ixGwQL3kXJ9Y5fwzmztV3LK5lvqR0hpbSOjoUETlCGF2Wg5YL9BJ56U9gKKYRennhs3ydog9Kn78gRw+SZU=
Message-ID: <a781481a0704231955h6cb4a220i4ce1c30cb09c1719@mail.gmail.com>
Date: Tue, 24 Apr 2007 08:25:08 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: Remove open coded implementations of memclear_highpage flush
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Jens Axboe" <jens.axboe@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0704231924390.4099@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0704231547080.975@schroedinger.engr.sgi.com>
	 <a781481a0704231919s584e55bfv99f45132b6f191c@mail.gmail.com>
	 <Pine.LNX.4.64.0704231924390.4099@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/24/07, Christoph Lameter <clameter@sgi.com> wrote:
> On Tue, 24 Apr 2007, Satyam Sharma wrote:
> > If I remember right, a very similar patchset was recently submitted
> > that Andrew merged in -mm(?). It also renamed memclear_highpage_flush
> > to something like zero_user_page (though I wonder how good a name that
> > is considering it takes an offset and not the whole page) and
> > deprecated the old name.
>
> My latest tree from Andrew does not have any of this. URL of patch?

fs-deprecate-memclear_highpage_flush.patch (and friends, search for
zero_user_page) in
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-04-11-02-24.tar.gz
