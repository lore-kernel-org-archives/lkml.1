Return-Path: <linux-kernel-owner+w=401wt.eu-S1752645AbXJBJGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbXJBJGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 05:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbXJBJG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 05:06:27 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:52137 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbXJBJG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 05:06:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Wg/vvb98wLLJXhyym39SyW9T1vreTb52xka7Eqrx2aprJoxAEpsWCpsQGlG78NTAHgkSXV50s1iRLYtgsCnUfaiEAeVlFODKVCwAxOdGbf5MXEuYkOUqg1BbHeIdGZYz2qTslxsimQuXPRgOxw58P20UzhhoNwdbRzLO8urQKVA=
Message-ID: <e85b9d30710020206w7563d93fp23a09e66ddb319fd@mail.gmail.com>
Date: Tue, 2 Oct 2007 11:06:24 +0200
From: Matthew <jackdachef@gmail.com>
To: "Bill Davidsen" <davidsen@tmr.com>
Subject: Re: [patch/backport] CFS scheduler, -v22, for v2.6.23-rc8, v2.6.22.8, v2.6.21.7, v2.6.20.20
Cc: linux-kernel@vger.kernel.org, mingo@chiara.csoma.elte.hu
In-Reply-To: <47003742.5090604@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e85b9d30709290411u4f48d716o3260bab7d71261ff@mail.gmail.com>
	 <47003742.5090604@tmr.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Try setting features to 14. That helps my similar issues.

Hi Bill,

thanks, but unfortunately that didn't help,

with 2.6.23-rc8 it's already set to 29,
it happens with 2.6.23-rc8 & with the new scheduler

what I found out so far:

it definitely is using 3D acceleration:
glxgears -info
GL_RENDERER   = GeForce 7600 GT/PCI/SSE2
GL_VERSION    = 2.1.1 NVIDIA 100.14.19
GL_VENDOR     = NVIDIA Corporation
GL_EXTENSIONS = GL_ARB_color_buffer_float GL_ARB_depth_texture
GL_ARB_draw_buffers GL_ARB_fragment_program
GL_ARB_fragment_program_shadow GL_ARB_fragment_shader
GL_ARB_half_float_pixel GL_ARB_imaging GL_ARB_multisample
GL_ARB_multitexture GL_ARB_occlusion_query GL_ARB_pixel_buffer_object
GL_ARB_point_parameters GL_ARB_point_sprite GL_ARB_shadow
GL_ARB_shader_objects GL_ARB_shading_language_100
GL_ARB_texture_border_clamp GL_ARB_texture_compression
GL_ARB_texture_cube_map GL_ARB_texture_env_add
GL_ARB_texture_env_combine GL_ARB_texture_env_dot3
GL_ARB_texture_float GL_ARB_texture_mirrored_repeat
GL_ARB_texture_non_power_of_two GL_ARB_texture_rectangle
GL_ARB_transpose_matrix GL_ARB_vertex_buffer_object
GL_ARB_vertex_program GL_ARB_vertex_shader GL_ARB_window_pos
GL_ATI_draw_buffers GL_ATI_texture_float GL_ATI_texture_mirror_once
GL_S3_s3tc GL_EXT_texture_env_add GL_EXT_abgr GL_EXT_bgra
GL_EXT_blend_color GL_EXT_blend_equation_separate
GL_EXT_blend_func_separate GL_EXT_blend_minmax GL_EXT_blend_subtract
GL_EXT_compiled_vertex_array GL_EXT_Cg_shader GL_EXT_depth_bounds_test
GL_EXT_draw_range_elements GL_EXT_fog_coord GL_EXT_framebuffer_blit
GL_EXT_framebuffer_multisample GL_EXT_framebuffer_object
GL_EXT_gpu_program_parameters GL_EXT_multi_draw_arrays
GL_EXT_packed_depth_stencil GL_EXT_packed_pixels
GL_EXT_pixel_buffer_object GL_EXT_point_parameters
GL_EXT_rescale_normal GL_EXT_secondary_color
GL_EXT_separate_specular_color GL_EXT_shadow_funcs
GL_EXT_stencil_two_side GL_EXT_stencil_wrap GL_EXT_texture3D
GL_EXT_texture_compression_s3tc GL_EXT_texture_cube_map
GL_EXT_texture_edge_clamp GL_EXT_texture_env_combine
GL_EXT_texture_env_dot3 GL_EXT_texture_filter_anisotropic
GL_EXT_texture_lod GL_EXT_texture_lod_bias GL_EXT_texture_mirror_clamp
GL_EXT_texture_object GL_EXT_texture_sRGB GL_EXT_timer_query
GL_EXT_vertex_array GL_IBM_rasterpos_clip
GL_IBM_texture_mirrored_repeat GL_KTX_buffer_region GL_NV_blend_square
GL_NV_copy_depth_to_color GL_NV_depth_clamp GL_NV_fence
GL_NV_float_buffer GL_NV_fog_distance GL_NV_fragment_program
GL_NV_fragment_program_option GL_NV_fragment_program2
GL_NV_framebuffer_multisample_coverage GL_NV_half_float
GL_NV_light_max_exponent GL_NV_multisample_filter_hint
GL_NV_occlusion_query GL_NV_packed_depth_stencil
GL_NV_pixel_data_range GL_NV_point_sprite GL_NV_primitive_restart
GL_NV_register_combiners GL_NV_register_combiners2
GL_NV_texgen_reflection GL_NV_texture_compression_vtc
GL_NV_texture_env_combine4 GL_NV_texture_expand_normal
GL_NV_texture_rectangle GL_NV_texture_shader GL_NV_texture_shader2
GL_NV_texture_shader3 GL_NV_vertex_array_range
GL_NV_vertex_array_range2 GL_NV_vertex_program GL_NV_vertex_program1_1
GL_NV_vertex_program2 GL_NV_vertex_program2_option
GL_NV_vertex_program3 GL_NVX_conditional_render
GL_SGIS_generate_mipmap GL_SGIS_texture_lod GL_SGIX_depth_texture
GL_SGIX_shadow GL_SUN_slice_accum

it's some kind of AIGLX:
GLX_EXT_texture_from_pixmap -> nvidia-native handling of compiz

* there are no problems with the metacity window manager

* it only occurs with compiz being enabled

* and it also happens with disabled "fair group cpu scheduler" (with
the new scheduler)

so it might be a problem with either the graphics driver (tainted !)
or the window manager (compiz),
compiz-fusion 0.6 will be out soon so I'll check it out if that will help

if it gotten clear until now:
the old & new cfs scheduler work perfectly fine:
no hickups & the like with default window manager (== metacity)

so the problem might be somewhere else

I'll collect scheduler configuration with the script posted by Ingo in
the next following days

(pretty busy right now)

thanks

Mat
