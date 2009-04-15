Return-Path: <linux-kernel-owner+w=401wt.eu-S1753965AbZDOPgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbZDOPgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 11:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbZDOPgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 11:36:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:12441 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbZDOPgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 11:36:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=L6rzm0DaB6L+dsyasRiq5ITNHPuNIQWlitrShOy/oeEixVwoNIMB5DVQOZPEBoQQgb
         KS2U+yMXByESUE907UO9lr3hRwUgBQhdov/9c2uCsfiVnpQTKSyfi4ySCtM2ier2/XSa
         HxktuPts3fzukFrMzPM1CyVuQKQI3Dp0roM8A=
Date: Wed, 15 Apr 2009 08:35:59 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Brown <broonie@sirena.org.uk>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 1/1] INPUT: mainstone-wm97xx, fix condition in pen_up
Message-ID: <20090415153559.GA17335@dtor-d630.eng.vmware.com>
References: <1239777830-17826-1-git-send-email-jirislaby@gmail.com> <20090415120032.GC9311@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415120032.GC9311@sirena.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 01:00:32PM +0100, Mark Brown wrote
> On Wed, Apr 15, 2009 at 08:43:50AM +0200, Jiri Slaby wrote:
> > The loop body was never executed, because the condition is
> > always false. Convert to for with more obvious condition.
> 
> > Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Applied, thanks Jiri.

-- 
Dmitry
