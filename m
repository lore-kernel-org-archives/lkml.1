Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbYGGOQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbYGGOQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 10:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbYGGOQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 10:16:24 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:24432 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbYGGOQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 10:16:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=a7UUyUtrjmhlQFxSn7mRju4k7fct0QDNcocqb8D6RxGSapCNayqZGBHb2Yu0HWlhVD
         5N6eDeTiPSZ5P+nFcf2QnSeukSEmMHT7zTOLgyIBmW8YEpj+Lmyz8aVVvtJKDjfoZjd5
         7i/dAPqBqzR3GxADgAfi+NAJsibNFiY68wh2A=
Message-ID: <e2e108260807070716k3a03bbbs120a249fc66ea90b@mail.gmail.com>
Date: Mon, 7 Jul 2008 16:16:21 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Jinkai Gao" <mickeygjk@gmail.com>
Subject: Re: Suggestion: LKM should be able to add system call for itself
Cc: linux-kernel@vger.kernel.org, "Arjan van de Ven" <arjan@infradead.org>,
       "Jan Engelhardt" <jengelh@computergmbh.de>
In-Reply-To: <fb82a8210807070536o3e6a1ed8ld05505b0d80112f3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fb82a8210807062209t6cfe3e46m50a11b577f0540e7@mail.gmail.com>
	 <e2e108260807070140l3f8eaf06w7ee7e8a4ae42f2c2@mail.gmail.com>
	 <fb82a8210807070536o3e6a1ed8ld05505b0d80112f3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 7, 2008 at 2:36 PM, Jinkai Gao <mickeygjk@gmail.com> wrote:
> Why the number of system calls is growing? because the kernel is
> growing. why we don't use the alternatives to implement the new need
> for system calls? Because it doesn't make any sense. We can't ignore
> the kernel modules' need for system calls just because they are
> loadable.

Arjan and Jan have already explained in detail why adding system calls
dynamically is troublesome.

Bart.
