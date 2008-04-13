Return-Path: <linux-kernel-owner+w=401wt.eu-S1756721AbYDMITn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721AbYDMITn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 04:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbYDMIT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 04:19:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:11498 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbYDMITY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 04:19:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LWsCBxeDNDpJDgjlgLNevUfHe0cFBl9zWW6KCSZP91JPC7CPvdNtwqsQSicl1tn/aNSxuJOKzDs4iwC7XkTLy4oZZUzMoNs4KsnF3LZuoH+oUxOg97WIlM8u4znNSrYuSoZLyUfuFBtrhDm9fLcnMSFwiBSdp81reh1k2SGWR6k=
Message-ID: <e2e108260804130119r27a2ccb8sc7f03b43c6177d33@mail.gmail.com>
Date: Sun, 13 Apr 2008 10:19:22 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Marc Perkel" <mperkel@yahoo.com>
Subject: Re: AMD Quad Core clock problem?
Cc: "Chris Snook" <csnook@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <735874.9676.qm@web52502.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47FFD3F3.50107@redhat.com>
	 <735874.9676.qm@web52502.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2008 at 12:09 AM, Marc Perkel <mperkel@yahoo.com> wrote:
>
>  Is it possible due to calibration that ntpd isn't able
>  to correct the problem? Is there a setting to make ntp
>  more agressive?

Clock crystals typically have an error between 20 and 200 ppm. ntpd
can correct clock crystal errors of maximum 500 ppm. If I remember
correctly the kernel limits frequency adjustments to 512 ppm. It's not
a good idea to try to change this limit -- large clock crystal errors
slow down convergence of ntpd's algorithms significantly.

Bart.
