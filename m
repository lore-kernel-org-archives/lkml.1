Return-Path: <linux-kernel-owner+w=401wt.eu-S1758662AbYFFOZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662AbYFFOZQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 10:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbYFFOZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 10:25:00 -0400
Received: from rn-out-0910.google.com ([64.233.170.189]:54680 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbYFFOZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 10:25:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=toGERVsWLsrMXfUg4zsIMQEcsB95m5WKzuN50BERKYIZgLoiqHqcQ38XHL2NRXwGQx
         +Y9DQLGS2SlgBuWY4IFbL31G1O6YxYGLpECs488N3iWMI9CGbGRmUyQPvcLa5giFhyW+
         E11odAM+dw7m/Wg7V6eNkoYzYEK7KypFFBLwM=
Date: Fri, 6 Jun 2008 10:24:53 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pau Oliva Fora <pau@eslack.org>
Cc: ?ric Piel <Eric.Piel@tremplin-utc.net>, Jonathan Cameron <jic23@cam.ac.uk>,
       Jean Delvare <khali@linux-fr.org>, Andrew Morton <akpm@osdl.org>,
       Burman <burman.yan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       HWMON <lm-sensors@lm-sensors.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Pavel Machek <pavel@suse.cz>, Yan@ATrpms.net, Dmitry@ATrpms.net,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [lm-sensors] [PATCH 2.6.25.4] hwmon: HP Mobile Data Protection
	System 3D ACPI driver -- please review!
Message-ID: <20080606102237.ZZRA012@mailhub.coreip.homeip.net>
References: <1212235533.3815.5.camel@localhost> <4846EBF5.2030406@tremplin-utc.net> <20080604225830.1dff64fc@hyperion.delvare> <20080604230510.GB30475@elf.ucw.cz> <484728B2.1000209@tremplin-utc.net> <20080605082950.6957f1a2@hyperion.delvare> <4847B415.2080708@cam.ac.uk> <48484DD6.3050706@tremplin-utc.net> <4848683E.4070709@eslack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4848683E.4070709@eslack.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jun 06, 2008 at 12:27:10AM +0200, Pau Oliva Fora wrote:
> From: Pau Oliva Fora <pau@eslack.org>
>
> Add support for HTC Shift UMPC G-Sensor LIS3LV02DL accelerometer.
>
> Signed-off-by: Pau Oliva Fora <pau@eslack.org>
>

The input piece looks good, however it seens that the input is the
only functionality that this driver exports so I don't see any reason
to make input device registration optional. Or are you planning on
adding more functions to it?

Thanks.

-- 
Dmitry
