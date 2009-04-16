Return-Path: <linux-kernel-owner+w=401wt.eu-S1754235AbZDPCLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbZDPCLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 22:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbZDPCLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 22:11:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:45029 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbZDPCLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 22:11:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=epgd25WXBRO45ga4Kdmv5uCGyHHlFxpDHmnI3tkG/4f+MbxKvph9oOpy+P8jzbxeII
         vHtKyIrzq5VDFNN3muIDh9Jjz+ub042cy9PMck1aPo7skg9UPYsDnmlTtQal0t7J7ADF
         P4w+APBWuF+H+ILqP5R/S2X8u2wM9SbwSIlkY=
Date: Wed, 15 Apr 2009 19:11:26 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Lukasz Stelmach <stlman@poczta.fm>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] use multitouch touchpad events as buttons mousedev
Message-ID: <20090416021126.GE2413@dtor-d630.eng.vmware.com>
References: <49B46ADA.5060809@poczta.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B46ADA.5060809@poczta.fm>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lukasz,

On Mon, Mar 09, 2009 at 02:03:22AM +0100, Lukasz Stelmach wrote:
> 
> Some touchpads can recognize multi-finger taps. They can be used as
> additional buttons (left and middle).
> 

mousedev is a legacy interface and I don't think this change is needed
since evdev + Synaptics X driver combination works much better with
touchpads anyway.

Thanks.

-- 
Dmitry
