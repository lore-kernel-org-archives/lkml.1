Return-Path: <linux-kernel-owner+w=401wt.eu-S1753710AbZG1TYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbZG1TYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 15:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbZG1TYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 15:24:08 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:14842 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbZG1TYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 15:24:07 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 03/12] SFI: document boot param "sfi=off"
Date: Tue, 28 Jul 2009 13:24:02 -0600
User-Agent: KMail/1.9.10
Cc: x86@kernel.org, sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
       Len Brown <len.brown@intel.com>
References: <1247026438-20891-1-git-send-email-lenb@kernel.org> <57dac60d76c191e3bd72f186833fac01e4c5f8f1.1247025117.git.len.brown@intel.com>
In-Reply-To: <57dac60d76c191e3bd72f186833fac01e4c5f8f1.1247025117.git.len.brown@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907281324.03237.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 July 2009 10:13:49 pm Len Brown wrote:
> From: Feng Tang <feng.tang@intel.com>
> 
> "sfi=off" is analogous to "acpi=off"
> 
> In practice, "sfi=off" isn't likely to be very useful, for
> 1. SFI is used only when ACPI is not available
> 2. Today's SFI systems are not legacy PC-compatible
> 
> ie. "sfi=off" on an ACPI-platform is a NO-OP,
> and "sfi=off" on an SFI-platform will likely result in boot failure.
> 
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  Documentation/kernel-parameters.txt |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)

I think the documentation update should be part of the patch
that changes the functionality, so the doc always matches the
code.

Bjorn

> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index d77fbd8..68337e6 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -92,6 +92,7 @@ parameter is applicable:
>  	SECURITY Different security models are enabled.
>  	SELINUX SELinux support is enabled.
>  	SERIAL	Serial support is enabled.
> +	SFI	Simple Firmware Interface
>  	SH	SuperH architecture is enabled.
>  	SMP	The kernel is an SMP kernel.
>  	SPARC	Sparc architecture is enabled.
> @@ -2162,6 +2163,10 @@ and is between 256 and 4096 characters. It is defined in the file
>  			If enabled at boot time, /selinux/disable can be used
>  			later to disable prior to initial policy load.
>  
> +	sfi=		[SFI,X86] Simple Firmware Interface
> +			Format: { "off" }
> +			off -- disable SFI
> +
>  	serialnumber	[BUGS=X86-32]
>  
>  	shapers=	[NET]


